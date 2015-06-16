#!/bin/bash

set -eu

package=$1
sha=$2

curl -L https://github.com/phacility/${package}/archive/${sha}.tar.gz | tar -xzf -
mv $package-$sha* /opt/$package
