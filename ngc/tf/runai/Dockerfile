ARG ngc_image_tag
FROM nvcr.io/nvidia/tensorflow:$ngc_image_tag

RUN pip install \
        Pillow \
        keras==2.2.4 \
        coloredlogs \
        prometheus_client==0.7.1 \
        runai

# this is to allow all users to use this directory in order
# to be able to run this Docker image as non-root users.
RUN mkdir /.horovod
RUN chmod -R 777 /.horovod

ARG cuda
ENV RUNAI_CUDA_VERSION=$cuda

RUN mkdir /workload

RUN cd /workload && git clone https://github.com/tensorflow/benchmarks.git && cd ..

WORKDIR /workload
