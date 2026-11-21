[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/code-server-2?utm_medium=integration&utm_source=button&utm_campaign=code-server)

# code-server on Railway

This repo is the source of the [code-server Railway template](https://railway.com/deploy/code-server-2). It deploys [code-server](https://github.com/coder/code-server) **4.146.0**, VS Code in the browser, from the official image pinned by digest:

`codercom/code-server:4.146.0@sha256:fc708b18f6c613b5a9d00f1d1801e58376d3df9c5b5de77f5c02d67b711f99c9`

## What the template deploys

| Service | Source | Public | Volume | Health check |
| --- | --- | --- | --- | --- |
| `code-server` | this repo (`Dockerfile`) | Railway domain, port `8080` | `/home/coder` | `/healthz` |

- `railway-start.sh` runs as root only to hand the Railway volume (mounted as root) to the `coder` user, then starts code-server as `coder` through the image's own entrypoint, so `/entrypoint.d` start-up scripts still work.
- Your projects live in `/home/coder/project`; settings, extensions and config live under `/home/coder`. All of it is on the volume.

## Variables

| Variable | Default | Notes |
| --- | --- | --- |
| `PASSWORD` | `${{secret(64,"abcdef0123456789")}}` | Login password, generated per deploy. Read it in the service's Variables tab. |
| `PORT` | `8080` | Port code-server listens on and the Railway domain targets. |

Optional, not set by the template: `HASHED_PASSWORD` (an argon2 hash instead of `PASSWORD`), `PROXY_DOMAIN` (for port forwarding through sub-domains), `CS_DISABLE_GETTING_STARTED_OVERRIDE`. See the [code-server FAQ](https://coder.com/docs/code-server/FAQ).

## Updates

Railway notifies everyone who deployed this template when a change is merged to `main`. Each version bump is listed in [CHANGELOG.md](./CHANGELOG.md), breaking changes first. Apply an update from the service in your Railway project when you're ready.

Deploys from before 2026-11-16 ran the image `codercom/code-server:4.130.0` directly and don't get update notices. To move one to this repo, set the service's source to `aalfath/code-server-railway` (Settings → Source), remove the custom start command, and keep the volume: the start script takes over the existing `/home/coder` data. The old `RAILWAY_RUN_UID` variable is then no longer needed.

Community-maintained; not affiliated with Coder Technologies, Inc.
