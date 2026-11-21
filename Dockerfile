# code-server for Railway: official image, pinned by version and digest.
FROM codercom/code-server:4.146.0@sha256:fc708b18f6c613b5a9d00f1d1801e58376d3df9c5b5de77f5c02d67b711f99c9

# Railway mounts volumes owned by root. The start script runs as root only long
# enough to prepare /home/coder, then runs code-server as the unprivileged `coder` user.
USER root
COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "/usr/local/bin/railway-start.sh"]
