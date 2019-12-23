#!/bin/bash 

# start message 
printf "\033[0;32m--- BUILD SITE: START ---\033[0m\n"

# build site 
pushd examples
Rscript -e 'install.packages("rmarkdown") ; rmarkdown::render_site()'
popd

# finish message 
printf "\033[0;32m--- BUILD SITE: DONE !!! ---\033[0m\n"
