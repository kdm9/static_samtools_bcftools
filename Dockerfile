FROM ubuntu:18.04 as builder

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install cmake zlib1g-dev libbz2-dev liblzma-dev libgsl-dev build-essential

ARG SAMTOOLS_VERSION=1.21
ARG LIBDEFLATE_VERSION=1.22

RUN mkdir -p /wd /target/bin

ADD https://github.com/ebiggers/libdeflate/releases/download/v${LIBDEFLATE_VERSION}/libdeflate-${LIBDEFLATE_VERSION}.tar.gz /wd/
RUN cd /wd && \
    tar xvf libdeflate-${LIBDEFLATE_VERSION}.tar.gz && \
    cd libdeflate-${LIBDEFLATE_VERSION} && \
    mkdir build && cd build &&  \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DLIBDEFLATE_BUILD_SHARED_LIB=OFF .. && \
    make -j8 && make install

ADD https://github.com/samtools/htslib/releases/download/${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION}.tar.bz2 /wd/
RUN cd /wd && \
    tar xvf htslib-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd htslib-${SAMTOOLS_VERSION} && \
    ./configure --disable-libcurl --with-libdeflate  && \
    make -j8 && make install 

ADD https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 /wd/
ADD ./static_samtools.mk /wd/
RUN ls /wd && cd /wd && \
    tar xvf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    mv ../static_samtools.mk ./ && \
    make -f static_samtools.mk -j8 static_samtools && \
    ldd samtools && cp samtools /target/bin

    
ADD https://github.com/samtools/bcftools/releases/download/${SAMTOOLS_VERSION}/bcftools-${SAMTOOLS_VERSION}.tar.bz2 /wd/
ADD ./static_bcftools.mk bcftools.sh /wd/
RUN cd /wd && \
    tar xvf bcftools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd bcftools-${SAMTOOLS_VERSION} && \
    mv ../static_bcftools.mk ../bcftools.sh ./ && \
    make -f static_bcftools.mk -j8 static_bcftools && \
    ldd bcftools && \
    chmod +x ./bcftools.sh && \
    cp bcftools.sh /target/bin/bcftools && \
    mkdir -p /target/libexec/bcftools/ && \
    cp bcftools plugins/*.so /target/libexec/bcftools/
