FROM jupyter/datascience-notebook

USER root
WORKDIR /root
ENV USER=root
ENV HOME=/root
ENV XDG_CACHE_HOME=/root

# APT
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y git net-tools nginx supervisor nodejs && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# PIP
RUN python -m pip install --upgrade pip setuptools
RUN python -m pip install numpy scipy matplotlib pandas sympy nose torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html 
RUN python -m pip install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu111/torch1.8/index.html opencv-python fvcore jupyterlab theme-darcula jupyterlab-drawio
RUN python -m pip install tensorflow keras #tensorflow-cloud 
RUN jupyter labextension install jupyterlab_voyager

# ArrayFire
RUN curl https://arrayfire.s3.amazonaws.com/3.8.0/ArrayFire-v3.8.0_Linux_x86_64.sh --output ArrayFire.sh
RUN chmod +x ArrayFire.sh && ./ArrayFire.sh --include-subdir --prefix=/opt
RUN echo /opt/arrayfire/lib64 > /etc/ld.so.conf.d/arrayfire.conf
RUN ldconfig
