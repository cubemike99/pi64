FROM ubuntu:18.04


ENV APP_PATH /root/pi64
WORKDIR $APP_PATH
ENV GOPATH=$APP_PATH/go PATH=$APP_PATH/go/bin:/usr/lib/go-1.10/bin:$PATH

RUN apt-get update \
    && apt-get -y install \
        bc \
        build-essential \
        cmake \
        device-tree-compiler \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        git \
        unzip \
        qemu-user-static \
        multistrap \
        zip \
        wget \
        dosfstools \
        kpartx \
        golang-1.10-go \
        rsync \
        kmod \
        bison \
        flex \
        libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

