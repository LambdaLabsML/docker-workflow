#!/bin/bash

docker build . -t chuanli11/ngc-pytorch-runai:latest --build-arg ngc_image_tag=22.06-py3 -f ngc/pytorch/runai/Dockerfile