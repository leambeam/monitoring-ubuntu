#!/usr/bin/env python3

from pathlib import Path
from jinja2 import Environment, FileSystemLoader, StrictUndefined

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
template_dir = root / "templates"

for template in template_dir.glob("*.j2"):
    if template.is_file():
        # strips '.j2' from '.yaml.j2'
        target = out_dir / template.with_suffix("").name
        target.write_text(
            env.get_template(template.name).render(),
            encoding="utf-8"
            )
