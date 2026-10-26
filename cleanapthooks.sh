#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

APT_DIR="/etc/apt"
HOOK_PATTERN='(Pre-Invoke|Post-Invoke|Pre-Install-Pkgs)'
while IFS= read -r -d '' file; do
    if ! grep -Eiq "$HOOK_PATTERN" "$file"; then
        continue
    fi
    if dpkg-query -S "$file" >/dev/null 2>&1; then
        echo "SKIP: $file"
        continue
    fi
    echo "DELETE: $file"
    rm -f -- "$file"

done < <(
    find "$APT_DIR" -type f \
        \( -name '*.conf' -o -path "$APT_DIR/apt.conf.d/*" \) \
        -print0
)

echo "APT hook cleanup complete"
