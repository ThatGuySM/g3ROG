from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

from PIL import Image

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from check_public_privacy import text_privacy_findings, validate, validate_pdf, validate_video  # noqa: E402
from reportlab.pdfgen import canvas  # noqa: E402


class PublicPrivacyTests(unittest.TestCase):
    def test_redacted_user_domain_is_allowed(self) -> None:
        self.assertEqual([], text_privacy_findings("User/domain: Redacted for publication review"))

    def test_local_profile_path_is_rejected(self) -> None:
        self.assertIn("Windows user profile path", text_privacy_findings(r"C:\Users\example\AppData\Local\Temp"))

    def test_unexpected_site_file_fails_closed(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            site = root / "_site"
            site.mkdir()
            (root / "index.html").write_text("safe", encoding="utf-8")
            (root / ".public-site-manifest").write_text("index.html\n", encoding="utf-8")
            (site / "index.html").write_text("safe", encoding="utf-8")
            (site / "unexpected.txt").write_text("safe", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "Unexpected files"):
                validate(root, site, root / ".public-site-manifest")

    def test_gps_image_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            root = Path(temp_dir)
            site = root / "_site"
            site.mkdir()
            image_path = root / "photo.jpg"
            image = Image.new("RGB", (4, 4), "white")
            exif = Image.Exif()
            exif[34853] = {1: "N", 2: (1.0, 2.0, 3.0), 3: "E", 4: (4.0, 5.0, 6.0)}
            image.save(image_path, exif=exif)
            (root / ".public-site-manifest").write_text("photo.jpg\n", encoding="utf-8")
            (site / "photo.jpg").write_bytes(image_path.read_bytes())
            with self.assertRaisesRegex(ValueError, "Location metadata|Private EXIF metadata"):
                validate(root, site, root / ".public-site-manifest")

    def test_quicktime_location_marker_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "clip.mov"
            path.write_bytes(b"container-com.apple.quicktime.location.ISO6709-value")
            with self.assertRaisesRegex(ValueError, "Location metadata"):
                validate_video(path, path.name)

    def test_altitude_less_iso6709_video_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "clip.mov"
            path.write_bytes(b"container-\xa9xyz+37.3317-122.0307/")
            with self.assertRaisesRegex(ValueError, "Location metadata"):
                validate_video(path, path.name)

    def test_pdf_local_profile_path_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "report.pdf"
            document = canvas.Canvas(str(path))
            document.drawString(72, 720, r"file:///C:/Users/example/AppData/Local/Temp/report.html")
            document.save()
            with self.assertRaisesRegex(ValueError, "Private"):
                validate_pdf(path, path.name)

    def test_pdf_private_link_annotation_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            path = Path(temp_dir) / "report.pdf"
            document = canvas.Canvas(str(path))
            document.drawString(72, 720, "Public report")
            document.linkURL("file:///C:/Users/example/private.txt", (72, 700, 200, 720))
            document.save()
            with self.assertRaisesRegex(ValueError, "Private"):
                validate_pdf(path, path.name)


if __name__ == "__main__":
    unittest.main()
