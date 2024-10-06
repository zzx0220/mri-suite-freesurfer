FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="zzx"
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for FreeSurfer
RUN apt-get update && apt-get -y install \
        bc \
        tar \
        zip \
        wget \
        curl \
        gawk \
        tcsh \
        libgomp1 \
        python2.7 \
        python3 \
        perl-modules \
        libxm4

# Download Freesurfer 7.4.1 from MGH and untar to /opt
RUN wget -N -qO- ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.4.1/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz | tar -xz -C /opt && chown -R root:root /opt/freesurfer && chmod -R a+rx /opt/freesurfer
# RUN curl https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.4.1/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz | tar -xz -C /opt && chown -R root:root /opt/freesurfer && chmod -R a+rx /opt/freesurfer

RUN apt-get update --fix-missing \
 && apt-get install -y bzip2 ca-certificates \
      libglib2.0-0 libxext6 libsm6 libxrender1 \
      git mercurial subversion curl grep sed dpkg \
      libxt6 libxcomposite1 libfontconfig1 libasound2 \
      gcc g++ libeigen3-dev zlib1g-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev \
      xvfb xfonts-100dpi xfonts-75dpi xfonts-cyrillic \
      unzip imagemagick jq vim python3-pip libxt-dev libxmu-dev 

RUN cat /opt/freesurfer/SetUpFreeSurfer.sh >> ~/.bashrc

# The brainstem and hippocampal subfield modules in FreeSurfer-dev require the Matlab R2014b runtime
ENV FREESURFER_HOME /opt/freesurfer
RUN fs_install_mcr R2014b
RUN wget -N -qO- "https://surfer.nmr.mgh.harvard.edu/fswiki/MatlabRuntime?action=AttachFile&do=get&target=runtime2014bLinux.tar.gz" | tar -xz -C $FREESURFER_HOME && chown -R root:root /opt/freesurfer/MCRv84 && chmod -R a+rx /opt/freesurfer/MCRv84

RUN pip3 install numpy nibabel scipy pandas