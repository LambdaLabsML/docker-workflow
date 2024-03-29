ARG CUDA_DOCKER_VERSION=11.2.2-devel-ubuntu20.04
FROM nvidia/cuda:${CUDA_DOCKER_VERSION}

# Arguments for the build. CUDA_DOCKER_VERSION needs to be repeated because
# the first usage only applies to the FROM tag.
# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ARG CUDA_DOCKER_VERSION=11.2.2-devel-ubuntu18.04
ARG TENSORFLOW_VERSION=2.5.0
ARG PYTORCH_VERSION=1.8.1+cu111
ARG PYTORCH_LIGHTNING_VERSION=1.5.9
ARG TORCHVISION_VERSION=0.9.1+cu111
ARG CUDNN_VERSION=8.1.1.33-1+cuda11.2
ARG NCCL_VERSION_USER="2.8.4-1+cuda11.2"
ARG MXNET_VERSION=1.8.0.post0

ARG PYSPARK_PACKAGE=pyspark==3.1.1
ARG SPARK_PACKAGE=spark-3.1.1/spark-3.1.1-bin-hadoop2.7.tgz

ARG PYTHON_VERSION=3.8

# to avoid interaction with apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

# Extract ubuntu distribution version and download the corresponding key.
# This is to fix CI failures caused by the new rotating key mechanism rolled out by Nvidia.
# Refer to https://forums.developer.nvidia.com/t/notice-cuda-linux-repository-key-rotation/212771 for more details.
RUN DIST=$(echo ${CUDA_DOCKER_VERSION#*ubuntu} | sed 's/\.//'); \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${DIST}/x86_64/3bf863cc.pub && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu${DIST}/x86_64/7fa2af80.pub
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-7 \
        git \
        curl \
        vim \
        wget \
        ca-certificates \
        libcudnn8=${CUDNN_VERSION} \
        libnccl2=${NCCL_VERSION_USER} \
        libnccl-dev=${NCCL_VERSION_USER} \
        libjpeg-dev \
        libpng-dev \
        python${PYTHON_VERSION} \
        python${PYTHON_VERSION}-dev \
        python${PYTHON_VERSION}-distutils \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers \
        openjdk-8-jdk-headless \
        openssh-client \
        openssh-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Open MPI
RUN wget --progress=dot:mega -O /tmp/openmpi-3.0.0-bin.tar.gz https://github.com/horovod/horovod/files/1596799/openmpi-3.0.0-bin.tar.gz && \
    cd /usr/local && \
    tar -zxf /tmp/openmpi-3.0.0-bin.tar.gz && \
    ldconfig && \
    mpirun --version

# Allow OpenSSH to talk to containers without asking for confirmation
RUN mkdir -p /var/run/sshd
RUN echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config

RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

# pinning pip to 21.0.0 as 22.0.0 cannot fetch pytorch packages from html linl
# https://github.com/pytorch/pytorch/issues/72045
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install --no-cache-dir -U --force pip~=21.0.0

# Install PyTorch, TensorFlow, Keras and MXNet
RUN pip install --no-cache-dir \
    torch==${PYTORCH_VERSION} \
    torchvision==${TORCHVISION_VERSION} \
    -f https://download.pytorch.org/whl/${PYTORCH_VERSION/*+/}/torch_stable.html
RUN pip install --no-cache-dir pytorch_lightning==${PYTORCH_LIGHTNING_VERSION}

RUN pip install --no-cache-dir future typing packaging
RUN pip install --no-cache-dir \
    tensorflow==${TENSORFLOW_VERSION} \
    keras \
    h5py

RUN pip install --no-cache-dir mxnet-cu112==${MXNET_VERSION}

# Install Spark stand-alone cluster.
RUN wget --progress=dot:giga "https://www.apache.org/dyn/closer.lua/spark/${SPARK_PACKAGE}?action=download" -O - | tar -xzC /tmp; \
    archive=$(basename "${SPARK_PACKAGE}") bash -c "mv -v /tmp/\${archive/%.tgz/} /spark"

# Install PySpark.
RUN pip install --no-cache-dir ${PYSPARK_PACKAGE}

# Install Horovod, temporarily using CUDA stubs
RUN HOROVOD_GPU_OPERATIONS=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 pip install horovod[tensorflow,pytorch]

# Copy examples from the horovod repo
RUN mkdir /examples
COPY ./horovod/examples/examples /examples

RUN mkdir /workload

RUN cd /workload && git clone -b pytorch/distributed https://github.com/LambdaLabsML/examples.git && cd ..