FROM ubuntu:20.04
LABEL name="stonne-simulators"
LABEL version="1.0"
LABEL url="https://github.com/stonne-simulator"
LABEL description="Docker for STONNE, OMEGA and SST-STONNE simulators"
LABEL maintainer="Adrian Fenollar Navarro <adrian.fenollarn@um.es>"

# Main imagen configuration
WORKDIR /
ENV DEBIAN_FRONTEND noninteractive

# Environment variables
ENV STONNE_FOLDER /STONNE
ENV OMEGA_FOLDER /OMEGA
ENV SST_FOLDER /SST-STONNE
ENV SST_CORE_ROOT $SST_FOLDER/src/sst-core
ENV SST_CORE_HOME $SST_FOLDER/local/sst-core
ENV SST_ELEMENTS_ROOT $SST_FOLDER/src/sst-elements-with-stonne
ENV SST_ELEMENTS_HOME $SST_FOLDER/local/sst-elements-with-stonne
ENV PATH $PATH:$SST_CORE_HOME/bin


############################################################
#                        BASE IMAGE
############################################################

# Install needed packages and Python dependencies
RUN apt-get update && \
    apt-get install -y \
            build-essential \
            cmake \
            automake \
            libtool-bin \
            python-dev \
            git \
            python3 \
            python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir \
         numpy==1.23.5 \ 
         pyyaml==6.0 \
         setuptools==45.2.0 \
         transformers==4.25.1


############################################################
#                   STONNE INSTALLATION
############################################################

# Download and build STONNE
RUN git clone https://github.com/stonne-simulator/stonne $STONNE_FOLDER && \
    make -C $STONNE_FOLDER/stonne all -j4 && \
    ln -s $STONNE_FOLDER/stonne/stonne /bin/stonne

# Install Python Frontend and TorchVision
RUN cd $STONNE_FOLDER/pytorch-frontend && \
    python3 setup.py install && \
    cd $STONNE_FOLDER/pytorch-frontend/stonne_connection/ && \
    python3 setup.py install && \
    pip3 install torchvision==0.8.2 --no-deps


############################################################
#                    OMEGA INSTALLATION
############################################################

# Download and build OMEGA
RUN git clone https://github.com/stonne-simulator/omega $OMEGA_FOLDER && \
    make -C $OMEGA_FOLDER/omega-code omega -j4 && \
    ln -s $OMEGA_FOLDER/omega-code/omega /bin/omega


############################################################
#                  SST-STONNE INSTALLATION
############################################################

# Download SST-Core and SST-Elements (with STONNE) and install them
RUN ln -s /usr/bin/aclocal /usr/bin/aclocal-1.13 && \
    ln -s /usr/bin/automake /usr/bin/automake-1.13 && \
    alias python=python2 && \
    alias python-config=python2-config && \
    export C=/usr/bin/gcc && \
    export CC=/usr/bin/gcc && \
    export CXX=/usr/bin/g++ && \
    mkdir -p $SST/src $SST/local && \
    \
    git clone --branch v11.1.0_Final https://github.com/sstsimulator/sst-core $SST_CORE_ROOT && \
    cd $SST_CORE_ROOT && \
    ./autogen.sh && \
    ./configure --prefix=$SST_CORE_HOME --disable-mpi && \
    make all -j4 && \
    make install && \
    \
    git clone --branch sparse_dataflows_project https://github.com/stonne-simulator/sst-elements-with-stonne $SST_ELEMENTS_ROOT && \
    cd $SST_ELEMENTS_ROOT && \
    ./autogen.sh && \
    ./configure --prefix=$SST_ELEMENTS_HOME --with-sst-core=$SST_CORE_HOME && \
    make all -j4 && \
    make install


ENTRYPOINT [ "/bin/bash" ]
