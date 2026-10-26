#!/usr/bin/env bash
set -euo pipefail

# Verify the RPM database without modifying it.
python3 - "$(rpm --eval '%{_dbpath}')/rpmdb.sqlite" <<'PYTHON'
import sqlite3
import sys
from pathlib import Path

database = Path(sys.argv[1])
if not database.is_file():
    raise SystemExit(f"RPM database not found: {database}")

connection = sqlite3.connect(database.as_uri() + "?mode=ro", uri=True)
try:
    result = connection.execute("PRAGMA quick_check").fetchall()
finally:
    connection.close()

if result != [("ok",)]:
    raise SystemExit(f"RPM database integrity check failed: {result}")
print("RPM database integrity check: ok")
PYTHON
