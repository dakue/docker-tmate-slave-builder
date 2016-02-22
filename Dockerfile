FROM debian:jessie

RUN set -x && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends git-core ca-certificates curl openssh-client build-essential pkg-config libtool libevent-dev libncurses5-dev libutempter-dev zlib1g-dev automake libssh-dev cmake ruby && \
  git clone https://github.com/tmate-io/tmate-slave.git && \
  mkdir /msgpack-c && \
  curl -sSL https://github.com/msgpack/msgpack-c/releases/download/cpp-1.4.0/msgpack-1.4.0.tar.gz | \
  tar xz --strip-components=1 -C /msgpack-c && \
  mkdir /libssh && \
  curl -sSL https://red.libssh.org/attachments/download/177/libssh-0.7.2.tar.xz | \
  tar xJ --strip-components=1 -C /libssh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["build-tmate-slave"]
