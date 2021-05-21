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

# ArrayFire
RUN curl https://arrayfire.s3.amazonaws.com/3.8.0/ArrayFire-v3.8.0_Linux_x86_64.sh --output ArrayFire.sh
RUN chmod +x ArrayFire.sh && ./ArrayFire.sh --include-subdir --prefix=/opt
RUN echo /opt/arrayfire/lib64 > /etc/ld.so.conf.d/arrayfire.conf
RUN ldconfig

USER jovyan

RUN conda install --quiet --yes tensorflow keras pytorch torchvision torchaudio opencv detectron2 fvcore jupyterlab jupyterlab-drawio theme-darcula cudatoolkit=11.1 -c pytorch -c nvidia -c conda-forge  && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
