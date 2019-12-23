# start from rocker/verse:latest 
FROM rocker/verse:latest 
LABEL maintainer="Haoen Cui cuihaoen.opensource@gmail.com"


##### startup ##################################################################
# use root user for build 
USER root 

# suppress warnings due to non-interactive front end 
ENV DEBIAN_FRONTEND="noninteractive"

# debian source list 
RUN echo "deb http://deb.debian.org/debian/ testing main" >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ 


##### install clang ############################################################
# debian clang package: https://clang.debian.net/
# the hard way: https://packages.debian.org/stretch/clang
RUN apt-get update \
    && apt-get install -y --no-install-recommends clang-7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ 

# create soft/symbolic link 
RUN ln -s /usr/bin/clang++-7 /usr/bin/clang++ \
    && ln -s /usr/bin/clang-7 /usr/bin/clang


##### install PyMC3 ############################################################
# download and install from source 
WORKDIR /tmp
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && chmod 770 -R /opt/miniconda3 \
    && chgrp -R staff /opt/miniconda3 \
    && ln -s /opt/miniconda3/bin/conda /usr/local/bin/conda \
    && ln -s /opt/miniconda3/bin/jupyter /usr/local/bin/jupyter 
ENV PATH=/opt/miniconda3/bin:${PATH}

# install relevant packages 
RUN conda update --yes conda \
    && conda install --quiet --yes --channel conda-forge ipython jupyterlab pymc3 seaborn \
    && rm /opt/miniconda3/pkgs/cache/* 

# reset working directory 
WORKDIR /


# ##### install rstan ############################################################
# install system dependencies for R packages 
RUN apt-get update \
    && apt-get install -y --no-install-recommends gfortran libudunits2-dev libgdal-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ 

# global site-wide config, neeeded for building packages
RUN mkdir -p $HOME/.R/ \
    && echo "CXX=clang++ -ftemplate-depth-256" >> $HOME/.R/Makevars \
    && echo "CC=clang" >> $HOME/.R/Makevars \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -fPIC -Wno-unused-variable -Wno-unused-function -Wno-unused-local-typedefs -Wno-ignored-attributes -Wno-deprecated-declarations" >> $HOME/.R/Makevars 

# install rstan
RUN install2.r --error --deps TRUE \
    inline \
    RcppEigen \
    StanHeaders \
    rstan \
    KernSmooth \
    loo \
    bayesplot \
    rstanarm \
    rstantools \
    shinystan \
    ggmcmc \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


##### install JAGS #############################################################
# install system dependencies for R packages 
RUN apt-get update \
    && apt-get install -y --no-install-recommends jags  

# install rjags
RUN install2.r --error --deps TRUE rjags


##### install OpenBUGS #########################################################
# installation guide: http://www.openbugs.net/w/Downloads 
# ... compilation has been successful on 64-bit Ubuntu using the g++-multilib package 
RUN apt-get update \
    && apt-get install -y --no-install-recommends autotools-dev m4 \
    && apt-get install -y --no-install-recommends autoconf \
    && apt-get install -y --no-install-recommends automake \
    # automake-1.11 has Illegal character in prototype and Prototype mismatch issues
    #&& apt-get install -y --no-install-recommends automake1.11 \
    && apt-get install -y g++-multilib \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ 

# download and unzip source 
RUN wget http://pj.freefaculty.org/Ubuntu/15.04/amd64/openbugs/openbugs_3.2.3.orig.tar.gz \
    && tar -zxvf openbugs_3.2.3.orig.tar.gz 

# compile from source 
WORKDIR /openbugs-3.2.3 
RUN ./configure && make && make install 

# install R2OpenBUGS
RUN install2.r --error --deps TRUE R2OpenBUGS

# reset working directory 
WORKDIR /

# clean up OpenBUGS 
RUN rm -rf /openbugs-3.2.3 
RUN rm openbugs_3.2.3.orig.tar.gz 


##### user setup ###############################################################
COPY scripts/docker-setup/Rprofile.site usr/local/lib/R/etc/Rprofile.site

##### cleanup ##################################################################
# clean up the tmp folder 
RUN rm -rf /tmp/*
