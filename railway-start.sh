#!/bin/sh
# Prepares the Railway volume at /home/coder, then starts code-server as `coder`.
set -eu

HOME_DIR=/home/coder
PORT="${PORT:-8080}"

if [ "$(id -u)" = "0" ]; then
  # First boot on an empty (root-owned) volume, or a volume from the old
  # image-based template: hand the whole home directory to `coder` once.
  if [ "$(stat -c %u "$HOME_DIR")" != "1000" ] || [ ! -f "$HOME_DIR/.railway-owned" ]; then
    echo "railway-start: setting ownership of $HOME_DIR to coder (one time)"
    chown -R 1000:1000 "$HOME_DIR"
  fi
  for d in "$HOME_DIR/project" "$HOME_DIR/.config/code-server" "$HOME_DIR/.local/share/code-server"; do
    mkdir -p "$d"
  done
  chown 1000:1000 "$HOME_DIR" "$HOME_DIR/project" "$HOME_DIR/.config" "$HOME_DIR/.config/code-server" \
    "$HOME_DIR/.local" "$HOME_DIR/.local/share" "$HOME_DIR/.local/share/code-server"
  touch "$HOME_DIR/.railway-owned" && chown 1000:1000 "$HOME_DIR/.railway-owned"
  # Keep the image's shell defaults (.bashrc, .profile) on a fresh volume.
  for f in .bashrc .profile .bash_logout; do
    if [ ! -e "$HOME_DIR/$f" ] && [ -e "/etc/skel/$f" ]; then
      cp "/etc/skel/$f" "$HOME_DIR/$f" && chown 1000:1000 "$HOME_DIR/$f"
    fi
  done
  exec setpriv --reuid=1000 --regid=1000 --init-groups env HOME="$HOME_DIR" USER=coder \
    /usr/bin/entrypoint.sh --bind-addr "0.0.0.0:$PORT" "$HOME_DIR/project"
fi

exec /usr/bin/entrypoint.sh --bind-addr "0.0.0.0:$PORT" "$HOME_DIR/project"
