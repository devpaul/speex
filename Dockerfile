# build: docker build -t wasm .
# run: docker
FROM ubuntu

RUN apt-get update && apt-get install -y git cmake gcc g++ python
RUN git clone https://github.com/juj/emsdk.git
WORKDIR /emsdk
ENV CXX=/usr/bin/g++
RUN ./emsdk install sdk-incoming-64bit binaryen-master-64bit
RUN ./emsdk activate sdk-incoming-64bit binaryen-master-64bit
