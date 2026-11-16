# code-server for Railway: official image, pinned by version and digest.
FROM codercom/code-server:4.145.2@sha256:09565f9e07f5624554e295e8bab0e2fec4a7c533eb3cff459ed6596a4d3d7c1c

# Railway mounts volumes owned by root. The start script runs as root only long
# enough to prepare /home/coder, then runs code-server as the unprivileged `coder` user.
USER root
COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
