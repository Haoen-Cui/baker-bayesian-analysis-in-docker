#!/bin/bash 

# start message 
printf "\033[0;32m--- CREATE INDEX MARKDOWN FILE: START ---\033[0m\n"

# remove existing file 
rm -f examples/index.md 
rm -f examples/index.Rmd 

# copy README and insert headers to index.md 
(echo \
"---
title: \"Baker Project\"
date: \"Rendered: $( date +'%b %d, %Y' )\"
---

" && cat README.md) > examples/index.Rmd 

# finish message 
printf "\033[0;32m--- CREATE INDEX MARKDOWN FILE: DONE !!! ---\033[0m\n"
