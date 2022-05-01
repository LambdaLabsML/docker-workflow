#!/bin/bash

docker build -f Dockerfile -t chuanli11/ngc-pytorch-runai:latest --build-arg ngc_image_tag=22.04-py3 --build-arg cuda=11.6 .