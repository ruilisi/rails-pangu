#!/bin/bash
docker run  -v $(pwd):/usr/src/app/ -it --rm rails-pangu bundle install
docker build -t rails-pangu -f Dockerfile .
