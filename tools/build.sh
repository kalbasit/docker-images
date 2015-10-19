#!/bin/sh

for i in */Rockerfile; do
  pushd `dirname $i`
  ./rocker build -var TRAVIS_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER -var COMMIT=$COMMIT --push --auth $DOCKER_USER:$DOCKER_PASS
  popd
done
