#!/bin/sh

for i in */Rockerfile; do
  push `dirname $i`
  ./rocker build -var TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER -var COMMIT=$COMMIT --push --auth $DOCKER_USER:$DOCKER_PASS
  popd
done
