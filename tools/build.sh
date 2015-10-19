#!/bin/sh

for i in */Rockerfile; do
  ./rocker build -f $i -var TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER -var COMMIT=$COMMIT --push --auth $DOCKER_USER:$DOCKER_PASS
done
