# Changelog

## 2026-11-21: restart after a crash or out-of-memory kill

- No breaking changes. Your files, extensions, settings and `PASSWORD` on the `/home/coder` volume are kept, and code-server stays at 4.146.0 (same image digest).
- **Fix:** when code-server's server process was killed, most often by the out-of-memory killer on a small service (Railway's Free plan gives 0.5 GB; code-server uses about 0.8–1 GB with a project open), code-server's own wrapper exited with code 0. Railway's default "On Failure" restart policy took that as a clean stop, so the service stayed down (502) until restarted by hand. The start script now runs code-server as a child and exits with code 1 whenever it stops without Railway asking it to, so Railway restarts it within seconds. A normal stop or redeploy (SIGTERM) still exits cleanly.
- `dumb-init` now runs as PID 1 in front of the start script (it was already in the image), so signals are forwarded and stray processes are reaped as before.
- Tip: if your service keeps restarting, give it at least 1 GB of RAM (Service → Settings → Resource limits on paid plans).

## 2026-11-21: code-server 4.146.0

- No breaking changes for this template. Your files, extensions and settings on the `/home/coder` volume and your `PASSWORD` are kept.
- code-server [v4.146.0](https://github.com/coder/code-server/releases/tag/v4.146.0) updates to VS Code 1.146.0 and adds the `--wait` flag, so `code-server --wait` works as `EDITOR`/`GIT_EDITOR`. Its switch to pnpm only affects people building code-server from source.
- Image: `codercom/code-server:4.146.0@sha256:fc708b18f6c613b5a9d00f1d1801e58376d3df9c5b5de77f5c02d67b711f99c9`.

## 2026-11-16: code-server 4.145.2, built from this repo

- **Breaking for manual migrations only:** the service now builds from this repo instead of running `codercom/code-server:4.130.0` directly. The image runs its start script as root and drops to `coder`, so the old `RAILWAY_RUN_UID=0` variable is no longer needed, and the old custom start command must be removed (it would override the new one).
- code-server 4.130.0 → **4.145.2** (`codercom/code-server:4.145.2@sha256:09565f9e07f5624554e295e8bab0e2fec4a7c533eb3cff459ed6596a4d3d7c1c`). Release notes: https://github.com/coder/code-server/releases
- On every start, files under `/home/coder` not owned by `coder` (a fresh root-owned volume, data from older deploys, files created over `railway ssh`) are handed back to `coder`.
- Fresh volumes get the image's `.bashrc` and `.profile`.
