#!/bin/bash
BUNDLE=true
while getopts ":B" opt; do
  case ${opt} in
    B)
      BUNDLE=false
      ;;
    \?) echo "Usage: ./build.sh [-B]"
      exit
      ;;
  esac
done

if [[ $BUNDLE == 'true' ]]; then
  docker run  -v $(pwd):/usr/src/app/ -it --rm ruby sh -c 'cd /usr/src/app/
  bundle config mirror.https://rubygems.org https://gems.ruby-china.com
  bundle install'
fi
docker build -t rails-pangu -f Dockerfile .
