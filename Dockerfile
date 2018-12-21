FROM debian:9.4-slim

RUN apt-get update && apt-get install -y ca-certificates

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		locales \
	&& rm -rf /var/lib/apt/lists/*

	
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		r-base \
		r-base-dev \
		r-recommended \
		libnlopt-dev \
        && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

RUN Rscript  -e "install.packages(c('Rserve'), dependencies=TRUE)" \
    && Rscript  -e "install.packages(c('jsonlite'), dependencies=TRUE)" \
    && Rscript  -e "install.packages(c('msgpack'), dependencies=TRUE)"
	
	
CMD [ "echo" , "Done"]


#RUN useradd -d /home/ubuntu -ms /bin/bash -g root -G sudo -p ubuntu ubuntu
#USER ubuntu
#WORKDIR /home/ubuntu

RUN useradd -d /home/ruser -ms /bin/bash -g root -G sudo -p password ruser
USER ruser
WORKDIR /home/ruser

#EXPOSE 6311
#ENTRYPOINT R -e "Rserve::run.Rserve(remote=TRUE)" 

EXPOSE 80
ENTRYPOINT R -e "Rserve::run.Rserve(remote=TRUE,websockets.qap=TRUE,websockets.port=80)" 