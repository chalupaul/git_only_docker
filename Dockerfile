# syntax=docker/dockerfile:1.19.0

FROM public.ecr.aws/amazonlinux/amazonlinux:minimal AS linux
# we want latest here
# hadolint ignore=DL3041
RUN dnf install -y \
    autoconf \
    automake \
    binutils \
    curl-devel \
    gcc \
    gettext \
    gettext-devel \
    git \
    glibc-static \
    glibc-devel \
    kernel-devel \
    kernel-headers \
    libcurl-devel \
    libstdc++-static \
    libssh2 \
    libssh2-devel \
    openssl \
    openssl-devel \
    pcre \
    pcre-devel \
    perl-devel \
    procps-ng \
    procps-ng-devel \
    util-linux \
    tar \
    tcl \
    tcl-devel \
    wget \
    zlib-static \
    zlib-devel && \
    dnf clean all

ARG GIT_VERSION="2.52.0"

RUN wget -q https://www.kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.gz && \
    tar xzf /git-$GIT_VERSION.tar.gz
#    wget http://musl.cc/x86_64-linux-musl-cross.tgz && \
#    tar xzf /x86_64-linux-musl-cross.tgz

#ENV PATH="/x86_64-linux-musl-cross/bin:$PATH:/git-core/bin"
ENV PATH="$PATH:/git-core/bin"
#ENV CFLAGS="$CFLAGS -static"

# --build x86_64-linux-musl-cross
WORKDIR /git-$GIT_VERSION

RUN mkdir /git-core && \
    ./configure --prefix="/git-core" --with-curl --with-openssl --without-expat && \
    make -j8 install


CMD ["/opt/git-core/bin/git", "--version"]