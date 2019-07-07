#!/bin/bash

# set -x
set -e

docker build --cache-from=imagemagick-heroku18 -t imagemagick-heroku18 .
# docker build --no-cache -t imagemagick-heroku18 .
mkdir -p build

docker run --rm -t -v $PWD/build:/data imagemagick-heroku18 sh -c 'cp -f /usr/src/imagemagick/build/*.tar.gz /data/'
