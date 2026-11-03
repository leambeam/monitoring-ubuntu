#!/usr/bin/env python3

import sys
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, StrictUndefined

if len(sys.argv) != 2:
    sys.exit("Usage: ./render.py <template-name>")

name = sys.argv[1]
root = Path(__file__).parent

env = Environment(
    loader=FileSystemLoader(root / "templates"),
    undefined=StrictUndefined,
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True,
)
env.globals["read"] = lambda p: (root / p).read_text(encoding="utf-8")

out_dir = root / "build"
out_dir.mkdir(exist_ok=True)
target = out_dir / f"{name}.yaml"
target.write_text(env.get_template(f"{name}.yaml.j2").render(), encoding="utf-8")
