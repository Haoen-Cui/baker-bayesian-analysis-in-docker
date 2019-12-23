#!/bin/bash

# start message 
printf "\033[0;32m--- CONVERT PYTHON NOTEBOOK TO MARKDOWN: START ---\033[0m\n"

# execute the jupyter notebooks and convert to markdown
pushd examples
for notebook in $( ls *.ipynb ); do
  printf "\033[0;32mConverting examples/$notebook...\033[0m\n"
  jupyter nbconvert --ExecutePreprocessor.timeout=-1 --to markdown --execute $notebook \
  && printf "\033[0;32mInserting headers to examples/$notebook...\033[0m\n" \
  && (echo \
      "---
title: \"Probabilistic Programming in Python\"
date: \"Rendered: $( date +'%b %d, %Y' )\"
---

" && cat ${notebook%.*}.md) > ${notebook%.*}_tmp.md \
  && rm ${notebook%.*}.md && mv ${notebook%.*}_tmp.md ${notebook%.*}.Rmd
done
popd

# finish message 
printf "\033[0;32m--- CONVERT PYTHON NOTEBOOK TO MARKDOWN: DONE !!! ---\033[0m\n"
