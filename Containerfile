FROM jupyter/base-notebook:notebook-6.4.12

USER root

RUN apt update -qq && \
    apt upgrade -y && \
    apt install -y \
        software-properties-common \
        lsof \
        less \
        libapparmor1 \
        libtiff5-dev \
        libfftw3-dev \
        libcairo2-dev \
        libx11-dev \
        x11-utils \
        psmisc \
        libclang-dev \
        gfortran \
        libv8-dev \
        libssh2-1-dev \
        git \
        git-lfs \
        curl \
        vim \
        libuser \
        libuser1-dev \
        libpq-dev \
        rrdtool \
        build-essential \
        libxml2-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        build-essential \
        cmake \
        libnlopt-dev \
        libboost-all-dev \
        wget && \
    apt-get clean

RUN pip install nbgitpuller && \
    jupyter serverextension enable --py nbgitpuller --sys-prefix

RUN mamba install -y -c conda-forge pandas numpy matplotlib && \
    mamba clean --all

USER $NB_USER

RUN git lfs install
