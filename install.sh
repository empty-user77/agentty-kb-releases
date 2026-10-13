#!/bin/sh
# Installs agentty-kb, the local server of the Knowledge Base plugin for Agentty.
#
#   curl -fsSL https://github.com/empty-user77/agentty-kb-releases/releases/latest/download/install.sh | sh
#
# It downloads the build for this machine from the latest release (or AGENTTY_KB_VERSION, e.g.
# v0.1.0), checks it against the release's SHA256SUMS and puts it in ~/.agentty/bin
# (or AGENTTY_KB_DIR). Nothing else on the machine is touched.
set -eu

repo="empty-user77/agentty-kb-releases"
dir="${AGENTTY_KB_DIR:-$HOME/.agentty/bin}"

case "$(uname -s)" in
  Darwin) os="apple-darwin" ;;
  Linux) os="unknown-linux-gnu" ;;
  *) echo "agentty-kb: no build for $(uname -s); macOS and Linux only." >&2; exit 1 ;;
esac
case "$(uname -m)" in
  arm64 | aarch64) arch="aarch64" ;;
  x86_64 | amd64) arch="x86_64" ;;
  *) echo "agentty-kb: no build for $(uname -m)." >&2; exit 1 ;;
esac
asset="agentty-kb-$arch-$os.tar.gz"

if [ -n "${AGENTTY_KB_VERSION:-}" ]; then
  base="https://github.com/$repo/releases/download/$AGENTTY_KB_VERSION"
else
  base="https://github.com/$repo/releases/latest/download"
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "agentty-kb: downloading $asset"
curl -fsSL "$base/$asset" -o "$tmp/$asset"
curl -fsSL "$base/SHA256SUMS" -o "$tmp/SHA256SUMS"

want="$(grep " $asset\$" "$tmp/SHA256SUMS" | cut -d' ' -f1)"
if command -v sha256sum >/dev/null 2>&1; then
  got="$(sha256sum "$tmp/$asset" | cut -d' ' -f1)"
else
  got="$(shasum -a 256 "$tmp/$asset" | cut -d' ' -f1)"
fi
if [ -z "$want" ] || [ "$want" != "$got" ]; then
  echo "agentty-kb: checksum mismatch for $asset; nothing was installed." >&2
  exit 1
fi

tar -xzf "$tmp/$asset" -C "$tmp"
mkdir -p "$dir"
mv -f "$tmp/agentty-kb" "$dir/agentty-kb"
chmod 755 "$dir/agentty-kb"

echo "agentty-kb: installed $("$dir/agentty-kb" --version) in $dir"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "agentty-kb: to run it yourself, add $dir to your PATH. The Agentty plugin finds it there either way." ;;
esac
