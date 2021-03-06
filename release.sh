#!/bin/bash
# Path to build.sh script
BUILD_SCRIPT=${1:-horovod/examples}

# docker hub username
USERNAME=${2:-chuanli11} 

# image name
IMAGE=`echo ${BUILD_SCRIPT} | tr / -` # select from ngc-tf-runai, horovod-examples

echo $IMAGE
echo $USERNAME

# ensure we're up to date
git pull

# bump version
docker run --rm -v "$PWD":/app treeder/bump --filename VERSION patch
version=`cat VERSION`
echo "version: $version"

# build it
./${BUILD_SCRIPT}/build.sh

# tag the latest build
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version