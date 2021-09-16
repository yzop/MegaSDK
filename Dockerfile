FROM debian:buster-slim
ARG MEGA_SDK_VERSION="latest"
ENV SDK_VER=$MEGA_SDK_VERSION
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
RUN apt-get -qq update && \
    apt-get -qq install -y \
                 git g++ gcc autoconf automake curl \
                 m4 libtool make libcurl4-openssl-dev \
                 libcrypto++-dev libsqlite3-dev libc-ares-dev \
                 libsodium-dev zlib1g-dev \
                 libssl-dev swig python python3 python3-pip && \
    apt-get -y autoremove
    
RUN pip3 install setuptools

RUN echo Version = v${SDK_VER} && \
    export VERSION=${SDK_VER} && \
    git clone https://github.com/meganz/sdk.git sdk && cd sdk && \
    git checkout v$VERSION && ./autogen.sh && \
    ./configure --disable-silent-rules --enable-python --with-sodium --without-freeimage --disable-examples && \
    make -j$(nproc --all) && \
    cd bindings/python/ && python3 setup.py bdist_wheel
