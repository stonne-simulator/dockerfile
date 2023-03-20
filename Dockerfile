FROM ubuntu:20.04
LABEL name="stonne-simulator"
LABEL version="1.0"
LABEL url="https://github.com/stonne-simulator"
LABEL description="Docker for STONNE and OMEGA simulators"
LABEL maintainer="Adrian Fenollar Navarro <adrian.fenollarn@um.es>"

# Main imagen configuration
WORKDIR /
ENV DEBIAN_FRONTEND noninteractive

# Environment variables
ENV STONNE_FOLDER /STONNE
ENV OMEGA_FOLDER /OMEGA


############################################################
#                        BASE IMAGE
############################################################

# Install needed packages and Python dependencies
RUN apt-get update && \
    apt-get install -y \
            build-essential \
            cmake \
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

ENTRYPOINT [ "/bin/bash" ]
