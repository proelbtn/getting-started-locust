#!/bin/sh

docker run -it --rm -u $(id -u) -v "$(pwd):/host" --workdir /host --env GOOGLE_CREDENTIALS=terraform.json "hashicorp/terraform:0.12.10" $@
