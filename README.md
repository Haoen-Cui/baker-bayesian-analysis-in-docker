## About

This project is named [`Baker`](https://haoen-cui.github.io/baker-bayesian-analysis-in-docker) because it provides a `Doc`**`ker`** image for **Ba**yesian analysis. In particular, it enables  

- [`PyMC3`](https://docs.pymc.io/) with [`Jupyter`](https://jupyterlab.readthedocs.io/en/stable/) and [`miniconda3`](https://docs.conda.io/en/latest/miniconda.html) 
- [`Stan`](https://mc-stan.org/) using `R` through [`rstan`](https://cran.r-project.org/web/packages/rstan/index.html) and other related packages 
- [`BUGS`](https://www.mrc-bsu.cam.ac.uk/software/bugs/), in particular [`OpenBUGS`](http://www.openbugs.net/w/FrontPage), using [`R2OpenBUGS`](https://cran.r-project.org/web/packages/R2OpenBUGS/index.html)
- [`JAGS`](http://mcmc-jags.sourceforge.net/) using [`rjags`](https://cran.r-project.org/web/packages/rjags/index.html)

The website for this project is available at [here](https://haoen-cui.github.io/baker-bayesian-analysis-in-docker). The project's goal is to help 

- *Students* to not need to install packages and complicated dependencies on their personal devices 
- *Professors*, *Instructors*, and *TAs* to relieve from being system admins for all their *students*
- *Practitioners* to quickly spin up an environment to test out something interesting they find on the internet and to share their work with the world in an easily reproducible manner  

If you find this project helpful, please consider staring it and sharing the words. If you have any comments, concerns, or questions, please feel free to raise an [issue](https://github.com/Haoen-Cui/baker-bayesian-analysis-in-docker/issues). 


## Motivation 

I was first introduced to `WinBUGS` in an undergraduate Bayesian analysis course. Not knowing much modern computing technologies at the time, I had to visit *the* lab to use their Windows machines which have the software installed. Then, a couple years flew by, I took another Bayesian class in grad school which also required `OpenBUGS`. To make things worse, [iOS dropped support for 32 bit programs](https://developer.apple.com/documentation/uikit/app_and_environment/updating_your_app_from_32-bit_to_64-bit_architecture) in the middle of the semester after I spent significant amount to time configuring `wine`, `OpenBUGS`, and `R2OpenBUGS` on my MacBook. I know *now is the time*.

> Be the change you wish to see. ---- Mahatma Gandhi 


## Usage 

Some basic (*very little*) general knowledge of [`Docker`](https://docs.docker.com/) is needed. If one is interested in learning more, this [tutorial](https://docker-curriculum.com/) is a great source. We will present below a few common use cases. 

The `Dockerfile` of this project is based on `rocker/verse:latest`, therefore sharing many similar usage. For example, to set up a `rstudio server` on local host, run 
```bash
docker run \
    -d \
    --rm \
    -p 8787:8787 \
    -e USER=<username> \
    -e PASSWORD=<password> \
    --name <container_name> \
    haoencui/baker
```
Then, visit `localhost:8787` in your browser with specified `<username>` and `<password>`. 

- `-d`: to start a container in detached mode; 
- `--rm`: automatically remove the container when it exits; 
- `-p`: publish container port to host, `hostPort:containerPort`. One can pass multiple `-p` options. `8787` is used by `rstudio server`; 
- `-e`: set environment variable, i.e. username and password for rstudio server. `PASSWORD` is required and cannot be `"rstudio"`. If `USER` is omitted, then `"rstudio"` is used as default; and 
- `--name`: name of container for identification, can be omitted. 

The `--volume` option (or `-v` in short) is also convenient to mount volume from local host (e.g. your laptop). For example, adding 
```bash
--volume $(pwd):/home/<username>/WORKSPACE
```
to the aforementioned `docker run` command will connect `~/WORKSPACE` inside the `Docker` container with current working directory (`pwd`) on your local host, i.e. the file system under the directory is shared and hence modification will be reflected in real time. For additional details on running `rstudio server`, please read [rocker wiki page](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image). 

To set up a `jupyter lab` on local host, run 
```bash
# WARNING: THIS PROBABLY WON'T WORK AND IS RUN AS ROOT WITHOUT AUTH
docker run \
    -d \
    --rm \
    -p 9999:9999 \
    --volume $(pwd):/WORKSPACE \
    haoencui/baker \
    /bin/bash -c \
    "jupyter notebook --allow-root --ip=0.0.0.0 --port=9999 --no-browser --NotebookApp.token='' --NotebookApp.password=''"
```
Then, visit `localhost:9999` in your browser without the need to sign in. 

If one needs to peek into the `Docker` container while it's running, use 
```bash
docker ps
```
to find the `<container-id>` and run as `root` user via 
```bash
docker exec -it <container-id> bash
```
and this will start a `bash` shell running inside the `Docker` container as identified by its ID. 

For one-off scripts, one can execute them via 
```bash
docker run --rm haoencui/baker /bin/bash -c "<some-command>"
```
For example, `<some-command>` can be `echo $HOME && echo $USER` or `Rscript file.R`. Don't forget the `--volume` option if you want to access or modify files on local host. But note that this will run as the `root` user so don't do something too crazy if you are also exposing your laptop's file system. 

Last but not least, don't forget to shutdown the containers using 
```bash
docker stop <container-id> 
```
and remove stopped containers, if you'd like
```bash
docker container prune	
```


## Contribution 

**Users wanted**: Please try out this project and let me know your thoughts. There are a few examples on the [project website](https://haoen-cui.github.io/baker-bayesian-analysis-in-docker) if you don't have a Bayesian model handy. 

I hacked together this project over a weekend before Christmas. This is also the first `Dcokerfile` I've ever built, so there are probably a lot of problems and room for improvements. Please feel free to raise an [issue](https://github.com/Haoen-Cui/baker-bayesian-analysis-in-docker/issues) and / or directly contribute. Your help is greatly appreciated. 


## Acknowledgement 

This project is greatly inspire by the [rocker project](https://www.rocker-project.org/), [@jrnold's `rstan` `Dockerfile`](https://hub.docker.com/r/jrnold/rstan/dockerfile), and [@jonzelner's `rstan` `Dockerfile`](https://hub.docker.com/r/jonzelner/rstan/dockerfile). 

Special thanks to [@jsal13](https://github.com/jsal13) and [@patrick-boueri](https://github.com/patrick-boueri) for helping me debug my messy `docker build` logs. 
