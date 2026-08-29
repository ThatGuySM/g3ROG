#!/usr/bin/env python3
from __future__ import annotations

import argparse
import html
import re
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.platypus import KeepTogether, Paragraph, SimpleDocTemplate, Spacer


def inline_markup(value: str) -> str:
    escaped = html.escape(value)
    escaped = re.sub(r"`([^`]+)`", r'<font name="Courier">\1</font>', escaped)
    return re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", escaped)


def build_story(markdown: str):
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name="ReportTitle", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=20, leading=24, textColor=colors.HexColor("#111827"), spaceAfter=18))
    styles.add(ParagraphStyle(name="SectionHeading", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=13, leading=16, textColor=colors.HexColor("#111827"), spaceBefore=13, spaceAfter=7))
    body_style = ParagraphStyle(name="ReportBody", parent=styles["BodyText"], fontName="Helvetica", fontSize=9.5, leading=13, textColor=colors.HexColor("#161616"), spaceAfter=6)
    bullet_style = ParagraphStyle(name="ReportBullet", parent=body_style, leftIndent=14, firstLineIndent=-8, bulletIndent=0, spaceAfter=4)
    story = []
    paragraph_lines: list[str] = []
    bullet_lines: list[str] = []

    def flush_paragraph() -> None:
        if paragraph_lines:
            story.append(Paragraph(inline_markup(" ".join(paragraph_lines)), body_style))
            paragraph_lines.clear()

    def flush_bullets() -> None:
        if bullet_lines:
            for item in bullet_lines:
                story.append(Paragraph(inline_markup(item), bullet_style, bulletText="-"))
            story.append(Spacer(1, 4))
            bullet_lines.clear()

    for raw_line in markdown.splitlines():
        line = raw_line.strip()
        if not line:
            flush_paragraph()
            flush_bullets()
        elif line.startswith("# "):
            flush_paragraph()
            flush_bullets()
            story.append(Paragraph(inline_markup(line[2:].strip()), styles["ReportTitle"]))
        elif line.startswith("## "):
            flush_paragraph()
            flush_bullets()
            story.append(KeepTogether([Paragraph(inline_markup(line[3:].strip()), styles["SectionHeading"]), Spacer(1, 1)]))
        elif line.startswith("- "):
            flush_paragraph()
            bullet_lines.append(line[2:].strip())
        else:
            flush_bullets()
            paragraph_lines.append(line)

    flush_paragraph()
    flush_bullets()
    return story


def page_footer(canvas, document) -> None:
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#6B7280"))
    page_text = f"Page {document.page}"
    page_width, _ = letter
    canvas.drawString((page_width - stringWidth(page_text, "Helvetica", 8)) / 2, 0.38 * inch, page_text)
    canvas.restoreState()


def main() -> int:
    parser = argparse.ArgumentParser(description="Render sanitized repository Markdown to PDF")
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    markdown = args.input.read_text(encoding="utf-8")
    title_match = re.search(r"^#\s+(.+)$", markdown, re.MULTILINE)
    title = title_match.group(1).strip() if title_match else args.input.stem
    args.output.parent.mkdir(parents=True, exist_ok=True)
    document = SimpleDocTemplate(str(args.output), pagesize=letter, rightMargin=0.65 * inch, leftMargin=0.65 * inch, topMargin=0.62 * inch, bottomMargin=0.62 * inch, title=title, author="", creator="g3ROG sanitized report exporter", subject="Public system report")
    document.build(build_story(markdown), onFirstPage=page_footer, onLaterPages=page_footer)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
