#!/bin/bash


# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=chuanli11
# image name
IMAGE=ngc-pytorch-runai


# ensure we're up to date
git pull

# bump version
docker run --rm -v "$PWD":/app treeder/bump patch
version=`cat VERSION`
echo "version: $version"


# build it
./build.sh

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