#!/bin/sh

# This script is intended to be bundled into the standalone releases.
# Runs code-server with the bundled node binary.

# More complicated than readlink -f or realpath to support macOS.
# See https://github.com/cdr/code-server/issues/1537
bin_dir() {
  # We read the symlink, which may be relative from $0.
  dst="$(readlink "$0")"
  # We cd into the $0 directory.
  cd "$(dirname "$0")" || exit 1
  # Now we can cd into the dst directory.
  cd "$(dirname "$dst")" || exit 1
  # Finally we use pwd -P to print the absolute path of the directory of $dst.
  pwd -P || exit 1
}

BIN_DIR=$(bin_dir)
if [ "$(uname)" = "Linux" ]; then
  export LD_LIBRARY_PATH="$BIN_DIR/../lib${LD_LIBRARY_PATH+:$LD_LIBRARY_PATH}"
elif [ "$(uname)" = "Darwin" ]; then
  export DYLD_LIBRARY_PATH="$BIN_DIR/../lib${DYLD_LIBRARY_PATH+:$DYLD_LIBRARY_PATH}"
fi
exec "$BIN_DIR/../lib/node" "$BIN_DIR/.." "$@"
