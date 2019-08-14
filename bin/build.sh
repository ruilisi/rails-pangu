#!/bin/bash
docker run  -v $(pwd):/usr/src/app/ -it --rm ruby sh -c 'cd /usr/src/app/
bundle config mirror.https://rubygems.org https://gems.ruby-china.com
bundle install'
docker build -t rails-pangu -f Dockerfile .
