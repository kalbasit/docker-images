#!/bin/sh

dest=$1
shift

for i in $@; do
  mkdir -p $dest/`dirname $i`
  cp $i $dest/$i
done
