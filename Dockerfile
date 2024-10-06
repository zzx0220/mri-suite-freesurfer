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
#RUN wget -N -q -O /tmp/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.4.1/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz

# Or instead, download the installer to this folder and build the image
COPY freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz /tmp/

RUN tar -xz -C /opt -f /tmp/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz
RUN rm /tmp/freesurfer-linux-ubuntu22_amd64-7.4.1.tar.gz

RUN chown -R root:root /opt/freesurfer && chmod -R a+rx /opt/freesurfer
RUN cat /opt/freesurfer/SetUpFreeSurfer.sh >> ~/.bashrc

RUN apt-get update --fix-missing \
 && apt-get install -y bzip2 ca-certificates \
      libglib2.0-0 libxext6 libsm6 libxrender1 \
      git mercurial subversion curl grep sed dpkg \
      libxt6 libxcomposite1 libfontconfig1 libasound2 \
      gcc g++ libeigen3-dev zlib1g-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev \
      xvfb xfonts-100dpi xfonts-75dpi xfonts-cyrillic \
      unzip imagemagick jq vim python3-pip libxt-dev libxmu-dev 
RUN apt-get update && \
      apt-get install -y libqt5gui5 && \
      rm -rf /var/lib/apt/lists/*

# The brainstem and hippocampal subfield modules in FreeSurfer-dev require the Matlab R2014b runtime
RUN echo 'FREESURFER_HOME=/opt/freesurfer' >> ~/.bashrc
ENV FREESURFER_HOME=/opt/freesurfer
RUN chmod +x /opt/freesurfer/bin/fs_install_mcr 
RUN /opt/freesurfer/bin/fs_install_mcr R2014b

COPY license.txt /opt/freesurfer/