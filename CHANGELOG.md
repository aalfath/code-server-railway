# Changelog

## 2026-11-16: code-server 4.145.2, built from this repo

- **Breaking for manual migrations only:** the service now builds from this repo instead of running `codercom/code-server:4.130.0` directly. The image runs its start script as root and drops to `coder`, so the old `RAILWAY_RUN_UID=0` variable is no longer needed, and the old custom start command must be removed (it would override the new one).
- code-server 4.130.0 → **4.145.2** (`codercom/code-server:4.145.2@sha256:09565f9e07f5624554e295e8bab0e2fec4a7c533eb3cff459ed6596a4d3d7c1c`). Release notes: https://github.com/coder/code-server/releases
- On every start, files under `/home/coder` not owned by `coder` (a fresh root-owned volume, data from older deploys, files created over `railway ssh`) are handed back to `coder`.
- Fresh volumes get the image's `.bashrc` and `.profile`.
