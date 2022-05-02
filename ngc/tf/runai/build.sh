#!/bin/bash

docker build . -t chuanli11/ngc-tf-runai:latest --build-arg ngc_image_tag=22.04-tf1-py3 --build-arg cuda=11.6 -f ngc/tf/runai/Dockerfile