#!/bin/bash
set -e

if [[ "$1" == 'build-tmate-slave' ]]
then
    echo "$(date -Iseconds) - INFO: Building msgpack-c ..."
    cd /msgpack-c
    cmake . && \
    make && \
    make install

    echo "$(date -Iseconds) - INFO: Building libssh ..."
    cd /libssh
    mkdir build
    cd build
    cmake .. -DWITH_SFTP=OFF -DWITH_PCAP=OFF -DWITH_GSSAPI=OFF && \
    make -C /libssh/build install

    echo "$(date -Iseconds) - INFO: Building tmate-slave ..."
    cd /tmate-slave
    ./autogen.sh && \
    ./configure && \
    make
    
    if mountpoint -q /target; then
        echo "Installing tmate-slave to /target"
        cp /tmate-slave/tmate-slave /target
        tar czf /target/tmate-slave-lib.tar.gz /usr/local/lib
    else
        echo '/target is not a mountpoint.'
        echo 'You can either:'
        echo '- re-run this container with -v $(pwd)/target:/target'
        echo '- extract the tmate-slave binary (located at /tmate-slave/tmate-slave)'
        echo '- extract the needed libraries (located at /usr/local/lib)'
    fi
else
    exec "$@"
fi
