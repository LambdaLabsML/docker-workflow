ARG ngc_image_tag
FROM nvcr.io/nvidia/pytorch:$ngc_image_tag

RUN mkdir /workload

RUN cd /workload && git clone -b pytorch/distributed https://github.com/LambdaLabsML/examples.git && cd ..

RUN apt-get update && apt install openssh-server

WORKDIR /workload
