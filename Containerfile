FROM quay.io/jupyter/base-notebook:notebook-7.5.5
USER root

ENV PIP_NO_CACHE_DIR=1

RUN sed -i 's,URIs: http://archive.ubuntu.com/ubuntu/,URIs: https://ftp.ucsb.edu/ubuntu,g;s,Suites: noble noble-updates noble-backports,Suites: noble noble-updates noble-backports noble-security,g' /etc/apt/sources.list.d/ubuntu.sources

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
    apt-get clean &&\
    ## Configure git lfs and R for all system users
    git config --system filter.lfs.clean "git-lfs clean -- %filter-replica" && \
    git config --system filter.lfs.smudge "git-lfs smudge -- %filter-replica" && \
    git config --system filter.lfs.process "git-lfs filter-process"

RUN mamba install -y -c conda-forge --freeze-installed\
    "jupyter-ai=2.*"\
    jupyterlab-git\
    jupyterthemes\
    langchain-openai\
    matplotlib\
    nbgitpuller\
    numpy\
    openai\
    pandas &&\
    conda clean -afy &&\
    jupyter server extension enable --py nbgitpuller --sys-prefix &&\
    chown -R $NB_USER:$NB_GID /home/jovyan &&\
    /usr/local/bin/fix-permissions "${CONDA_DIR}" || true

USER $NB_USER
