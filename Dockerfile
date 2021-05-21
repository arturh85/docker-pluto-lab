FROM jupyter/scipy-notebook

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Julia installation
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
# Check https://julialang.org/downloads/
ARG julia_version="1.6.1"
# SHA256 checksum
ARG julia_checksum="7c888adec3ea42afbfed2ce756ce1164a570d50fa7506c3f2e1e2cbc49d52506"

RUN apt-get update && apt-get install -y --no-install-recommends curl && curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
# R pre-requisites
RUN apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    git net-tools nginx supervisor nodejs \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia \
    JULIA_PKGDIR=/opt/julia \
    JULIA_VERSION="${julia_version}"

WORKDIR /tmp

# hadolint ignore=SC2046
RUN mkdir "/opt/julia-${JULIA_VERSION}" && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/$(echo "${JULIA_VERSION}" | cut -d. -f 1,2)"/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    echo "${julia_checksum} *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf "julia-${JULIA_VERSION}-linux-x86_64.tar.gz" -C "/opt/julia-${JULIA_VERSION}" --strip-components=1 && \
    rm "/tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz" && \
    ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir "${JULIA_PKGDIR}" && \
    chown "${NB_USER}" "${JULIA_PKGDIR}" && \
    fix-permissions "${JULIA_PKGDIR}"

# ArrayFire
RUN curl https://arrayfire.s3.amazonaws.com/3.8.0/ArrayFire-v3.8.0_Linux_x86_64.sh --output ArrayFire.sh
RUN chmod +x ArrayFire.sh && ./ArrayFire.sh --include-subdir --prefix=/opt
RUN echo /opt/arrayfire/lib64 > /etc/ld.so.conf.d/arrayfire.conf
RUN ldconfig

USER $NB_UID

# R packages including IRKernel which gets installed globally.
RUN conda install --quiet --yes \
    'r-base=4.0.3'  \
    'r-caret=6.0*' \
    'r-crayon=1.4*' \
    'r-devtools=2.4*' \
    'r-forecast=8.14*' \
    'r-hexbin=1.28*' \
    'r-htmltools=0.5*' \
    'r-htmlwidgets=1.5*' \
    'r-irkernel=1.1*' \
    'r-nycflights13=1.0*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.98*' \
    'r-rmarkdown=2.7*' \
    'r-rsqlite=2.2*' \
    'r-shiny=1.6*' \
    'r-tidyverse=1.3*' \
    'rpy2=3.4*'
    
RUN mamba install --quiet --yes \
    'tensorflow=2.4.1' keras pytorch torchvision opencv jupyterlab jupyterlab-drawio theme-darcula -c conda-forge && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Add Julia packages.
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("HDF5")' && \
    julia -e 'using Pkg; pkg"add IJulia"; pkg"precompile"' && \
    # move kernelspec out of home \
    mv "${HOME}/.local/share/jupyter/kernels/julia"* "${CONDA_DIR}/share/jupyter/kernels/" && \
    chmod -R go+rx "${CONDA_DIR}/share/jupyter" && \
    rm -rf "${HOME}/.local" && \
    fix-permissions "${JULIA_PKGDIR}" "${CONDA_DIR}/share/jupyter"

WORKDIR $HOME