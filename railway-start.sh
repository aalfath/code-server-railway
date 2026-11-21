#!/bin/sh
# Prepares the Railway volume at /home/coder, then starts code-server as `coder`.
set -eu

HOME_DIR=/home/coder
PORT="${PORT:-8080}"

if [ "$(id -u)" = "0" ]; then
  # Hand anything not owned by `coder` (an empty root-owned volume on first
  # boot, files from the old image-based template, files created over
  # `railway ssh` as root) back to `coder`. Cheap when nothing needs changing.
  find "$HOME_DIR" -xdev \( ! -user 1000 -o ! -group 1000 \) -exec chown -h 1000:1000 {} + 2>/dev/null || true
  for d in "$HOME_DIR/project" "$HOME_DIR/.config/code-server" "$HOME_DIR/.local/share/code-server"; do
    mkdir -p "$d"
  done
  chown 1000:1000 "$HOME_DIR" "$HOME_DIR/project" "$HOME_DIR/.config" "$HOME_DIR/.config/code-server" \
    "$HOME_DIR/.local" "$HOME_DIR/.local/share" "$HOME_DIR/.local/share/code-server"
  # Keep the image's shell defaults (.bashrc, .profile) on a fresh volume.
  for f in .bashrc .profile .bash_logout; do
    if [ ! -e "$HOME_DIR/$f" ] && [ -e "/etc/skel/$f" ]; then
      cp "/etc/skel/$f" "$HOME_DIR/$f" && chown 1000:1000 "$HOME_DIR/$f"
    fi
  done
  set -- setpriv --reuid=1000 --regid=1000 --init-groups env HOME="$HOME_DIR" USER=coder \
    /usr/bin/entrypoint.sh
else
  set -- /usr/bin/entrypoint.sh
fi

# Run code-server as a child instead of exec'ing it. If its server process is
# killed (for example by the out-of-memory killer when the service has too
# little RAM), code-server's own wrapper exits with code 0, and Railway's
# default "On Failure" restart policy treats that as a clean stop: the service
# would stay down until restarted by hand. So unless Railway asked us to stop
# (SIGTERM/SIGINT), exit non-zero, and Railway restarts the service.
set +e
stopping=0
child=
on_stop() {
  stopping=1
  if [ -n "$child" ]; then kill -TERM "$child" 2>/dev/null; fi
}
trap on_stop TERM INT

"$@" --bind-addr "0.0.0.0:$PORT" "$HOME_DIR/project" &
child=$!
rc=0
while :; do
  wait "$child"
  rc=$?
  kill -0 "$child" 2>/dev/null || break
done

if [ "$stopping" = 1 ]; then
  exit "$rc"
fi
echo "railway-start: code-server stopped unexpectedly (exit $rc); exiting 1 so Railway restarts the service" >&2
exit 1
