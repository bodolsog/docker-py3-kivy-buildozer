FROM ubuntu:17.04

ENV DIR '/src'

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8

ENV CYTHON_VERSION=0.25.2
ENV CRYSTAX_VERSION=10.3.2

RUN set -ex \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y build-essential libtool python-dev libportmidi-dev libswscale-dev libavformat-dev \
        libavcodec-dev libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev python3-kivy python3-pip \
        git unzip zlib1g-dev zlib1g:i386 openjdk-8-jdk libgtk2.0-0:i386 libpangox-1.0-0:i386 libpangoxft-1.0-0:i386 \
        libidn11:i386 lib32stdc++6 libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev \
        libc6-dev libbz2-dev wget libstdc++6:i386 bsdtar autotools-dev autoconf sudo

RUN set -ex \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 \
    && pip install Cython==$CYTHON_VERSION

RUN set -ex \
    && useradd kivy -mN \
    && echo "kivy:kivy" | chpasswd \
    && mkdir -p $DIR \
    && chown kivy:users /opt \
    && chown kivy:users /src

RUN set -ex \
    && sudo -u kivy -i \
    && cd /opt \
    && git clone https://github.com/kivy/buildozer \
    && cd buildozer \
    && python setup.py build \
    && pip install -e . \
    && sed -i -e 's/build.gradle/~build.gradle/g' /opt/buildozer/buildozer/targets/android.py

RUN set -ex \
    && sudo -u kivy -i \
    && cd /opt \
    && wget https://www.crystax.net/download/crystax-ndk-${CRYSTAX_VERSION}-linux-x86_64.tar.xz \
    && bsdtar xf crystax-ndk-${CRYSTAX_VERSION}-linux-x86_64.tar.xz \
    && rm crystax-ndk-${CRYSTAX_VERSION}-linux-x86_64.tar.xz

RUN ln -s /usr/local/bin/buildozer /bin/buildozer

RUN mkdir /buildozer && chown kivy /buildozer

WORKDIR $DIR

USER kivy

