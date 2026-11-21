# Changelog

## 2026-11-21: code-server 4.146.0

- No breaking changes for this template. Your files, extensions and settings on the `/home/coder` volume and your `PASSWORD` are kept.
- code-server [v4.146.0](https://github.com/coder/code-server/releases/tag/v4.146.0) updates to VS Code 1.146.0 and adds the `--wait` flag, so `code-server --wait` works as `EDITOR`/`GIT_EDITOR`. Its switch to pnpm only affects people building code-server from source.
- Image: `codercom/code-server:4.146.0@sha256:fc708b18f6c613b5a9d00f1d1801e58376d3df9c5b5de77f5c02d67b711f99c9`.

## 2026-11-16: code-server 4.145.2, built from this repo

- **Breaking for manual migrations only:** the service now builds from this repo instead of running `codercom/code-server:4.130.0` directly. The image runs its start script as root and drops to `coder`, so the old `RAILWAY_RUN_UID=0` variable is no longer needed, and the old custom start command must be removed (it would override the new one).
- code-server 4.130.0 → **4.145.2** (`codercom/code-server:4.145.2@sha256:09565f9e07f5624554e295e8bab0e2fec4a7c533eb3cff459ed6596a4d3d7c1c`). Release notes: https://github.com/coder/code-server/releases
- On every start, files under `/home/coder` not owned by `coder` (a fresh root-owned volume, data from older deploys, files created over `railway ssh`) are handed back to `coder`.
- Fresh volumes get the image's `.bashrc` and `.profile`.
