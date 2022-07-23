# docker-workflow


## Usage


### Test build

```
export DOCKER_BUILDKIT=1 && \
./${BUILD_SCRIPT}/build.sh

# e.g.
export DOCKER_BUILDKIT=1 && \
./horovod/examples/build.sh

export DOCKER_BUILDKIT=1 && \
./ngc/tf/runai/build.sh

export DOCKER_BUILDKIT=1 && \
./ngc/pytorch/runai/build.sh
```

### Build and release
```
export DOCKER_BUILDKIT=1 && \
./release <BUILD_SCRIPT> <USERNAME>

# e.g. 
export DOCKER_BUILDKIT=1 && \
./release.sh horovod/examples chuanli11

export DOCKER_BUILDKIT=1 && \
./release.sh ngc/tf/runai chuanli11

export DOCKER_BUILDKIT=1 && \
./release.sh ngc/pytorch/runai chuanli11
```

## Usage

### Horovod PyTorch example

```
docker run --gpus all --rm --shm-size=128g -it \
chuanli11/horovod-examples:latest

cd /examples/pytorch && \
horovodrun -np 2 python pytorch_synthetic_benchmark.py |& tee $(date +"%m-%d-%y-%H-%M").txt
```

### NGC TensorFlow example

```
docker run --gpus all --rm --shm-size=128g -it \
chuanli11/ngc-tf-runai:latest

cd benchmarks && \
NCCL_DEBUG=INFO \
python scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
--model=resnet50 --num_batches=100 --data_name imagenet \
--batch_size=256 --num_gpus=2 |& tee $(date +"%m-%d-%y-%H-%M").txt

cd benchmarks && \
NCCL_DEBUG=INFO NCCL_ALGO=Ring NCCL_NET_GDR_LEVEL=4 horovodrun -np 2 \
python scripts/tf_cnn_benchmarks/tf_cnn_benchmarks.py \
--model=resnet50 --num_batches=100 --data_name cifar10 \
--batch_size=256 --variable_update=horovod |& tee $(date +"%m-%d-%y-%H-%M").txt
```