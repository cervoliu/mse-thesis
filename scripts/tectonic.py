"""Run Tectonic, retaining raw output and filtering known font-path noise."""

import os
from pathlib import Path
import re
import subprocess
import sys


FONT = (
    r"(?:/System/Library/Fonts/(?:Supplemental/)?"
    r"|/Applications/Microsoft Word\.app/Contents/Resources/DFonts/)"
    r"[^/`]+\.(?:ttf|ttc|otf)"
)
ABSOLUTE = re.compile(
    rf"warning: accessing absolute path `({FONT})`; "
    r"build may not be reproducible in other environments"
)
AUXILIARY = re.compile(
    rf"warning: open of input (({FONT})(?:/rsrc|:0-0-GID|:0-UCS32-Add)) failed"
)


def main():
    log_path = Path(sys.argv[1])
    command = sys.argv[2:]
    hidden = 0
    pending = None
    with log_path.open("w", encoding="utf-8") as log:
        try:
            process = subprocess.Popen(
                command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                text=True, encoding="utf-8", errors="replace",
                env={**os.environ, "NO_COLOR": "1"},
            )
        except OSError as error:
            message = f"error: cannot run {command[0]}: {error}\n"
            log.write(message)
            sys.stderr.write(message)
            return 127
        for line in process.stdout:
            log.write(line)
            log.flush()
            message = line.rstrip("\r\n")
            if pending:
                original, path = pending
                pending = None
                if message == f"caused by: access to the path `{path}` is forbidden":
                    hidden += 1
                    continue
                print(original, end="", flush=True)
            match = ABSOLUTE.fullmatch(message)
            if match and Path(match[1]).is_file():
                hidden += 1
                continue
            match = AUXILIARY.fullmatch(message)
            if match and Path(match[2]).is_file():
                pending = (line, match[1])
                continue
            print(line, end="", flush=True)
        if pending:
            print(pending[0], end="", flush=True)
        result = process.wait()
    if hidden:
        print(f"note: suppressed {hidden} known font-path warnings; full output: {log_path}")
    return result if result >= 0 else 128 - result


if __name__ == "__main__":
    sys.exit(main())
