#!/bin/bash 

docker run --rm -v $(pwd):/WORKSPACE haoencui/baker /bin/bash -c \
    "cd /WORKSPACE && ./scripts/render-site/make-index.sh" && \
docker run --rm -v $(pwd):/WORKSPACE haoencui/baker /bin/bash -c \
    "cd /WORKSPACE && ./scripts/render-site/convert-ipynb-to-md.sh" && \
docker run --rm -v $(pwd):/WORKSPACE haoencui/baker /bin/bash -c \
    "cd /WORKSPACE && ./scripts/render-site/build-site.sh"
