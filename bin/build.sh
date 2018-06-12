#!/bin/bash

# DEBUG
set -x
set -e

cd "$(dirname ${BASH_SOURCE[0]})"/..
mkdir -p ./release

# DEBUG
pwd
ls -la
docker run --rm --volume=${PWD}:/srv2 ubuntu /bin/bash -c "ls -la /srv2"

# let gulp build the assets
docker run --rm --label=gulp \
    --volume=$(pwd):/srv \
    huli/gulp \
    build

# and then let hugo build the site
docker run --rm --label=hugo \
    --volume=$(pwd):/src \
    --volume=$(pwd)/release:/tmp/build \
    -e HUGO_ENV=production \
    jojomi/hugo:0.40.2 \
    ash -c "rm -rf /tmp/build/* && hugo --config config.toml,config-$1.toml --destination /tmp/build"
