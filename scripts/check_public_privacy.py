#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

from PIL import ExifTags, Image
from pypdf import PdfReader
from pypdf.generic import ArrayObject, ByteStringObject, DictionaryObject, IndirectObject, TextStringObject


TEXT_SUFFIXES = {".css", ".html", ".js", ".json", ".md", ".txt", ".xml", ".yaml", ".yml"}
MEDIA_SUFFIXES = {".jpg", ".jpeg", ".mov", ".mp4"}
FORBIDDEN_SEGMENTS = {
    ".git",
    ".github",
    ".trash",
    "audits",
    "backup",
    "backups",
    "browser-data",
    "browser-profile",
    "drafts",
    "logs",
    "private",
    "raw",
}
FORBIDDEN_FILENAMES = {
    ".env",
    "bookmarks",
    "cookies",
    "history",
    "login data",
    "web data",
}
PRIVATE_TEXT_PATTERNS = {
    "Windows user profile path": re.compile(r"(?i)C:\\Users\\[^\\\s<>]+"),
    "local file URI": re.compile(r"(?i)file:/+"),
    "macOS user profile path": re.compile(r"(?i)/Users/[^/\s<>]+"),
    "Linux user profile path": re.compile(r"(?i)/home/[^/\s<>]+"),
    "Windows AppData path": re.compile(r"(?i)\\AppData\\"),
    "Windows temporary path": re.compile(r"(?i)\\Temp\\"),
    "domain-qualified username": re.compile(r"\b[A-Z][A-Z0-9._-]{1,30}\\[A-Za-z0-9._-]{2,}\b"),
}
ISO6709_PATTERN = re.compile(rb"[+-]\d{2,3}\.\d{3,}[+-]\d{2,3}\.\d{3,}(?:[+-]\d+(?:\.\d+)?)?/")
MEDIA_LOCATION_MARKERS = (
    b"gpslatitude",
    b"gpslongitude",
    b"gpscoordinates",
    b"locationcreated",
    b"locationshown",
    b"location.iso6709",
    b"com.apple.quicktime.location",
    b"sublocation",
    b"\xa9xyz",
)
SAFE_JPEG_EXIF_TAGS = {"Orientation", "ResolutionUnit", "XResolution", "YCbCrPositioning", "YResolution"}


def fail(message: str) -> None:
    raise ValueError(message)


def read_manifest(manifest_path: Path) -> list[str]:
    entries: list[str] = []
    for raw_line in manifest_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if "\\" in line or line.startswith("/") or ".." in Path(line).parts:
            fail(f"Manifest path is not a normalized repository-relative path: {line}")
        if any(character in line for character in "*?[]{}"):
            fail(f"Manifest path may not contain wildcards: {line}")
        if line in entries:
            fail(f"Manifest path is duplicated: {line}")
        entries.append(line)
    if not entries:
        fail("Public-site manifest is empty")
    return entries


def validate_manifest_entry(entry: str) -> None:
    path = Path(entry)
    lower_parts = {part.lower() for part in path.parts}
    if lower_parts & FORBIDDEN_SEGMENTS:
        fail(f"Forbidden private path is present in the public-site manifest: {entry}")
    lower_name = path.name.lower()
    if lower_name in FORBIDDEN_FILENAMES or lower_name.startswith(".env"):
        fail(f"Forbidden private filename is present in the public-site manifest: {entry}")
    if any(word in lower_name for word in ("credential", "secret")):
        fail(f"Credential-like filename is present in the public-site manifest: {entry}")


def text_privacy_findings(text: str) -> list[str]:
    findings = [name for name, pattern in PRIVATE_TEXT_PATTERNS.items() if pattern.search(text)]
    for line in text.splitlines():
        if re.search(r"(?i)user\s*/?\s*domain\s*:", line) and not re.search(
            r"(?i)user\s*/?\s*domain\s*:\s*(?:\[?redacted|<user>)", line
        ):
            findings.append("unredacted user/domain field")
            break
    return sorted(set(findings))


def strong_binary_privacy_findings(text: str) -> list[str]:
    excluded = {"domain-qualified username"}
    return sorted(name for name, pattern in PRIVATE_TEXT_PATTERNS.items() if name not in excluded and pattern.search(text))


def validate_jpeg(path: Path, relative: str) -> None:
    with Image.open(path) as image:
        exif = image.getexif()
        for tag, value in exif.items():
            name = str(ExifTags.TAGS.get(tag, tag))
            if value and name not in SAFE_JPEG_EXIF_TAGS:
                fail(f"Private EXIF metadata found in public image: {relative} ({name})")
    lower_content = path.read_bytes().lower()
    if any(marker in lower_content for marker in MEDIA_LOCATION_MARKERS) or ISO6709_PATTERN.search(lower_content):
        fail(f"XMP/IPTC location metadata found in public image: {relative}")


def validate_video(path: Path, relative: str) -> None:
    content = path.read_bytes()
    lower_content = content.lower()
    if any(marker in lower_content for marker in MEDIA_LOCATION_MARKERS) or ISO6709_PATTERN.search(content):
        fail(f"Location metadata found in public video: {relative}")


def validate_pdf(path: Path, relative: str) -> None:
    reader = PdfReader(str(path))
    page_text = [page.extract_text() or "" for page in reader.pages]
    if any(not text.strip() for text in page_text):
        fail(f"Public PDF page has no extractable text and requires manual OCR review: {relative}")
    text = "\n".join(page_text)
    metadata_text = "\n".join(str(value) for value in (reader.metadata or {}).values() if value)
    object_text: list[str] = []
    seen: set[int] = set()
    dangerous_keys = {"/AA", "/EmbeddedFile", "/EmbeddedFiles", "/JS", "/JavaScript", "/Launch", "/OpenAction"}

    def walk(value) -> None:
        if isinstance(value, IndirectObject):
            key = (value.idnum << 16) + value.generation
            if key in seen:
                return
            seen.add(key)
            walk(value.get_object())
        elif isinstance(value, DictionaryObject):
            for key, item in value.items():
                if str(key) in dangerous_keys:
                    fail(f"Active or embedded PDF content is not publishable: {relative} ({key})")
                walk(item)
            if hasattr(value, "get_data"):
                try:
                    data = value.get_data()
                except Exception:
                    data = b""
                decoded_stream = data.decode("utf-8", errors="ignore") + "\n" + data.decode("latin-1", errors="ignore")
                stream_findings = strong_binary_privacy_findings(decoded_stream)
                if stream_findings:
                    fail(f"Private binary metadata found in public PDF {relative}: {', '.join(stream_findings)}")
        elif isinstance(value, (ArrayObject, list, tuple)):
            for item in value:
                walk(item)
        elif isinstance(value, (TextStringObject, str)):
            object_text.append(str(value))
        elif isinstance(value, (ByteStringObject, bytes)):
            data = bytes(value)
            object_text.extend((data.decode("utf-8", errors="ignore"), data.decode("utf-16le", errors="ignore"), data.decode("latin-1", errors="ignore")))

    walk(reader.trailer)
    raw = path.read_bytes()
    raw_findings = strong_binary_privacy_findings(raw.decode("latin-1", errors="ignore"))
    if raw_findings:
        fail(f"Private raw metadata found in public PDF {relative}: {', '.join(raw_findings)}")
    findings = text_privacy_findings(text + "\n" + metadata_text + "\n" + "\n".join(object_text))
    if findings:
        fail(f"Private text found in public PDF {relative}: {', '.join(findings)}")


class ReferenceParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.references: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        for name, value in attrs:
            if name.lower() in {"href", "src"} and value:
                self.references.append(value)


def validate_local_references(path: Path, relative: str, site_root: Path) -> None:
    suffix = path.suffix.lower()
    text = path.read_text(encoding="utf-8", errors="replace")
    references: list[str] = []
    if suffix == ".md":
        references.extend(match.group(1).strip().split()[0] for match in re.finditer(r"!?\[[^\]]*\]\(([^)]+)\)", text))
    elif suffix == ".html":
        parser = ReferenceParser()
        parser.feed(text)
        references.extend(parser.references)
    elif suffix == ".css":
        references.extend(match.group(1).strip(" \"'") for match in re.finditer(r"url\(([^)]+)\)", text, re.IGNORECASE))
    else:
        return

    site_resolved = site_root.resolve()
    for reference in references:
        parsed = urlsplit(reference)
        if parsed.scheme or reference.startswith(("#", "//")) or not parsed.path:
            continue
        target = (site_resolved / unquote(parsed.path).lstrip("/")) if reference.startswith("/") else (path.parent / unquote(parsed.path))
        target = target.resolve()
        if site_resolved not in target.parents and target != site_resolved:
            fail(f"Public reference escapes the site root: {relative} -> {reference}")
        if not target.is_file():
            fail(f"Public reference target is missing: {relative} -> {reference}")


def validate_file(path: Path, relative: str) -> None:
    suffix = path.suffix.lower()
    if suffix in {".jpg", ".jpeg"}:
        validate_jpeg(path, relative)
    elif suffix in {".mov", ".mp4"}:
        validate_video(path, relative)
    elif suffix == ".pdf":
        validate_pdf(path, relative)
    elif suffix in TEXT_SUFFIXES:
        text = path.read_text(encoding="utf-8", errors="replace")
        findings = text_privacy_findings(text)
        if findings:
            fail(f"Private text found in public file {relative}: {', '.join(findings)}")


def validate(repo_root: Path, site_root: Path, manifest_path: Path) -> None:
    entries = read_manifest(manifest_path)
    expected = set(entries)
    for entry in entries:
        validate_manifest_entry(entry)
        source = repo_root / entry
        if not source.is_file():
            fail(f"Manifest source does not exist: {entry}")

    actual = {
        path.relative_to(site_root).as_posix()
        for path in site_root.rglob("*")
        if path.is_file()
    }
    unexpected = sorted(actual - expected)
    missing = sorted(expected - actual)
    if unexpected:
        fail(f"Unexpected files are present in the public site: {', '.join(unexpected)}")
    if missing:
        fail(f"Manifest files are missing from the public site: {', '.join(missing)}")

    for relative in sorted(actual):
        path = site_root / relative
        validate_file(path, relative)
        validate_local_references(path, relative, site_root)


def main() -> int:
    parser = argparse.ArgumentParser(description="Fail closed on unexpected or privacy-sensitive public files")
    parser.add_argument("--repo-root", type=Path)
    parser.add_argument("--site-root", type=Path)
    parser.add_argument("--manifest", type=Path)
    parser.add_argument("--file", type=Path, help="Validate one publishable file, such as a generated PDF")
    args = parser.parse_args()
    try:
        if args.file:
            file_path = args.file.resolve()
            if not file_path.is_file():
                fail(f"Publishable file does not exist: {file_path}")
            validate_file(file_path, file_path.name)
        elif args.repo_root and args.site_root and args.manifest:
            validate(args.repo_root.resolve(), args.site_root.resolve(), args.manifest.resolve())
        else:
            fail("Provide --file or all of --repo-root, --site-root, and --manifest")
    except (OSError, ValueError) as error:
        print(f"[FAIL] {error}", file=sys.stderr)
        return 1
    print("[OK] Public privacy validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
