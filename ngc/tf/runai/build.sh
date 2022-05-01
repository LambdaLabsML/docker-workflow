#!/bin/bash

docker build -f Dockerfile -t chuanli11/ngc-tf-runai:latest --build-arg ngc_image_tag=21.05-tf1-py3 --build-arg cuda=11.3 .