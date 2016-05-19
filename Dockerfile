FROM ubuntu:xenial

MAINTAINER Simon Oulevay (Alpha Hydrae) <docker@alphahydrae.com>

# Install nginx and curl (and xz-utils to decompress the node.tar.xz archive)
RUN apt-get update \
    && apt-get install -q -y curl nginx xz-utils

# Install Node.js.
RUN curl -sSLo /tmp/node.tar.xz https://nodejs.org/dist/v4.4.4/node-v4.4.4-linux-x64.tar.xz \
    && tar -C /usr/local --strip-components 1 -xf /tmp/node.tar.xz \
    && rm -f /tmp/node.tar.xz

# Install s6 (for service supervision: https://github.com/just-containers/s6-overlay).
RUN curl -sSLo /tmp/s6.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz \
    && tar xzf /tmp/s6.tar.gz -C / \
    && rm -f /tmp/s6.tar.gz

# Install serf.
RUN mkdir /opt/bin \
    && curl -sSLo /tmp/serf.gz https://releases.hashicorp.com/serf/0.7.0/serf_0.7.0_linux_amd64.zip \
    && gunzip -c /tmp/serf.gz > /opt/bin/serf \
    && chmod 755 /opt/bin/serf \
    && rm -f /tmp/serf.gz

# Clean up.
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/init"]
