#!/usr/bin/env bash
APPLY=false
[[ "${1:-}" == "--apply" ]] && APPLY=true

if [[ $EUID -ne 0 ]]; then
    echo "Run as root"
    exit 1
fi

PAM_DIRS=(
    /usr/lib/*/security
    /lib/*/security
    /usr/lib/security
    /lib/security
    /usr/local/lib/security
)

for dir in "${PAM_DIRS[@]}"; do
    [[ -d "$dir" ]] || continue
    while IFS= read -r -d '' module; do
        if dpkg-query -S "$module" >/dev/null 2>&1; then
            echo "SKIP $module"
            continue
        fi

        resolved=$(readlink -f -- "$module") || continue

        if dpkg-query -S "$resolved" >/dev/null 2>&1; then
            echo "SKIP $module"
            continue
        fi

        echo "FLAGGED $module"

        if [[ "$APPLY" == true ]]; then
            rm -f -- "$module"
            echo "DELETED $module"
        fi

    done < <(
        find "$dir" -maxdepth 1 \
            \( -type f -o -type l \) \
            -name 'pam_*.so' -print0
    )
done

dpkg --verify libpam-modules libpam-modules-bin \
    libpam-runtime libpam0g || true

echo
echo "PAM cleanup complete"
