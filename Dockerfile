FROM ubuntu:18.04

ENV http_proxy http://192.168.1.57:8080/ 
ENV https_proxy http://192.168.1.57:8080/


ENV APP_PATH /root/pi64
WORKDIR $APP_PATH
ENV GOPATH=$APP_PATH/go PATH=$APP_PATH/go/bin:/usr/lib/go-1.10/bin:$PATH

RUN apt-get update \
    && apt-get -y install \
        bc \
        build-essential \
        cmake \
        device-tree-compiler \
        gcc-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
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

