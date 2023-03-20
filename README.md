# Docker for STONNE, OMEGA and SST-STONNE simulation tools

This repository contains a single Dockerfile to build a Docker image with
all different simulations developed from STONNE. It includes:

- [STONNE](https://github.com/stonne-simulator/stonne): a cycle-level microarchitectural simulator for flexible DNN inference accelerators 
- [OMEGA](https://github.com/stonne-simulator/omega): a simulation framework for modeling efficiency of Graph Neural Network Dataflows based on STONNE
- [SST-STONNE](https://github.com/stonne-simulator/sst-elements-with-stonne): SST Simulator with STONNE integrated as a component, given support for sparse matrix multiplications using Flexagon

Please refer to the repository of each to find more information about them.

## How to use

The Docker image is available at [Docker Hub](https://hub.docker.com/r/stonnesimulator/) (it requires ~12GB available). You download and run the image directly running the following command:

```bash
docker run -it stonnesimulator/stonne-simulators
```

In case you want to rebuild the image with the latest version of each simulator, you can use the following command (from the root of this repository):

```bash
docker build -t <your_image_name> .
```

## File structure

All the main executables are directly accesible by their executables names(`stonne`, `omega` and `sst`), which are included in the system path. All simulators folders can be found at root directory with their respective name (`/STONNE`, `/OMEGA` and `/SST-STONNE`).