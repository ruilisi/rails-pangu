#!/bin/bash
docker build -t rails-devise-jwt -f Dockerfile .
docker run  -v $(PWD):/usr/src/app/ -it --rm rails-devise-jwt bundle install
