#!/usr/bin/env python3
"""Compile public-API cases and inspect PDF pagination using Poppler tools."""

import json
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / "build" / "checks"


def run(*args):
    result = subprocess.run(args, cwd=ROOT, text=True, capture_output=True)
    if result.returncode or "warning:" in result.stderr:
        raise AssertionError(f"{' '.join(map(str, args))}\n{result.stdout}{result.stderr}")
    return result.stdout


def compile_case(name, options, body, *, pages=None, error=None):
    source = BUILD / f"{name}.typ"
    pdf = source.with_suffix(".pdf")
    source.write_text(
        '#import "/src/lib.typ": slides\n'
        f"#show: slides.with({options})\n{body}\n", encoding="utf-8"
    )
    command = ["typst", "compile", "--root", str(ROOT), str(source), str(pdf)]
    if error:
        result = subprocess.run(command, cwd=ROOT, text=True, capture_output=True)
        assert result.returncode and error in result.stderr, (name, result.stderr)
        return
    run(*command)
    info = run("pdfinfo", str(pdf))
    count = int(re.search(r"Pages:\s+(\d+)", info).group(1))
    if pages is not None:
        assert count == pages, (name, count, pages)
    text = run("pdftotext", "-layout", str(pdf), "-")
    headings = json.loads(run(
        "typst", "eval", "--root", str(ROOT), "--in", str(source),
        "query(heading).map(it => (level: it.level, page: it.location().page()))",
    ))
    return count, text, headings, info


def check_package():
    with tempfile.TemporaryDirectory(prefix="claude-package-") as directory:
        sandbox = Path(directory)
        packages = sandbox / "packages"
        package = packages / "local" / "typst-claude-ppt" / "0.1.0"
        package.mkdir(parents=True)
        shutil.copy2(ROOT / "typst.toml", package)
        for name in ("src", "assets", "template"):
            shutil.copytree(ROOT / name, package / name)
        consumer = sandbox / "consumer"
        run("typst", "init", "--package-path", str(packages),
            "@local/typst-claude-ppt:0.1.0", str(consumer))
        main = consumer / "main.typ"
        pdf = consumer / "main.pdf"
        run("typst", "compile", "--package-path", str(packages), str(main), str(pdf))
        assert re.search(r"Pages:\s+6", run("pdfinfo", str(pdf)))
        (consumer / "sample.svg").write_text(
            '<svg xmlns="http://www.w3.org/2000/svg" width="240" height="80">'
            '<rect width="240" height="80" rx="8" fill="#f0eee6"/>'
            '<circle cx="120" cy="40" r="18" fill="#d97757"/></svg>', encoding="utf-8"
        )
        with main.open("a", encoding="utf-8") as stream:
            stream.write('\n== 独立项目资源\n#card(title: [文稿自己的图片])[\n'
                         '#figure(image("sample.svg", width: 60%, alt: "图片路径测试"), caption: [调用方图片])\n]\n'
                         '\n```python\nprint("package-owned syntax theme")\n```\n')
        run("typst", "compile", "--package-path", str(packages), str(main), str(pdf))
        assert "调用方图片" in run("pdftotext", str(pdf), "-")
    print("PASS: isolated @local import, typst init, package theme and consumer image")


def main():
    BUILD.mkdir(parents=True, exist_ok=True)
    body = "= 第一章\n== 内容甲\n正文。\n= 第二章\n== 内容乙\n末页。"
    for name, ratio, expected_width in (("wide", "16/9", 529.134), ("standard", "4/3", 396.850)):
        _, text, headings, info = compile_case(
            name, f'title: "测试文稿", authors: ("甲", "乙"), ratio: {ratio}', body, pages=6
        )
        assert [h["page"] for h in headings] == [3, 4, 5, 6]
        assert "SECTION 01" in text and "SECTION 02" in text
        assert "目录" in text and "甲、乙 | 测试文稿" in text
        assert re.search(r"6\s*/\s*6", text)
        width = float(re.search(r"Page size:\s+([\d.]+)", info).group(1))
        assert abs(width - expected_width) < 0.01

    _, text, headings, _ = compile_case("no-toc", 'title: "文稿", toc: false', body, pages=5)
    assert "目录" not in text and [h["page"] for h in headings] == [2, 3, 4, 5]
    _, text, _, _ = compile_case("no-footer", 'title: "文稿", authors: "作者", footer: false', body, pages=6)
    assert "作者 |" not in text and not re.search(r"\d+\s*/\s*6", text)
    _, text, headings, _ = compile_case("no-sections", 'title: "文稿"', "== 一\n正文\n== 二\n正文", pages=4)
    assert "目录" in text and [h["page"] for h in headings] == [3, 4]
    compile_case("cover-only", 'title: "文稿"', "", pages=1)
    compile_case("adjacent", 'title: "文稿", toc: false', "= 甲\n= 乙\n== 一\n== 二\n结尾", pages=5)
    _, text, _, _ = compile_case("manual-break", 'title: "文稿", toc: false', "== 一\n第一页\n#pagebreak()\n第二页", pages=3)
    assert "续" in text
    count, text, headings, _ = compile_case("overflow", 'title: "文稿", toc: false', "== 长文\n#lorem(700)\n= 后章\n== 末页\n结束")
    assert count > 5 and headings[-1]["page"] == count and text.count("续") >= 2
    many = "\n".join(f"= 章节{i}\n== 内容{i}\n正文" for i in range(1, 19))
    count, text, headings, _ = compile_case("long-toc", 'title: "文稿"', many)
    assert headings[0]["page"] > 3 and headings[-1]["page"] == count
    assert text.count("目录") >= 2
    _, text, _, _ = compile_case("authorless", 'title: [中文 *Title*], authors: none, date: datetime(year: 2026, month: 10, day: 30)', "== 内容\n正文", pages=3)
    assert "2026-10-30" in text and "|" not in text
    _, text, _, _ = compile_case("long-footer", 'title: "文稿", authors: "' + "Author " * 40 + '"', "== 内容\n正文")
    assert "…" in text
    compile_case("bad-ratio", 'title: "文稿", ratio: 1', "", error="ratio must be 16/9 or 4/3")
    compile_case("missing-title", "", "", error="title must be non-empty")
    compile_case("bad-authors", 'title: "文稿", authors: (1,)', "", error="authors must contain only strings")
    compile_case("removed-option", 'title: "文稿", layout: "medium"', "", error="unexpected argument")
    print("PASS: pagination, ratios, TOC, footers, metadata, continuation and invalid arguments")
    check_package()


if __name__ == "__main__":
    main()
