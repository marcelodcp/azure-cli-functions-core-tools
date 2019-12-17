FROM ubuntu:16.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NODEJS_APT_ROOT "node_8.x"
ENV NODEJS_VERSION "8.15.0"

RUN apt-get update -qq && apt-get install -y --no-install-recommends apt-utils

RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
      apt-transport-https \
      build-essential \
      curl \
      ca-certificates \
      git \
      lsb-release \
      python-all \
      rlwrap \
      vim \
      nano \
      jq && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://deb.nodesource.com/${NODEJS_APT_ROOT}/pool/main/n/nodejs/nodejs_${NODEJS_VERSION}-1nodesource1_amd64.deb > node.deb && \
	dpkg -i node.deb && \
    rm node.deb

RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    	gpg --dearmor | \
    	tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
	AZ_REPO=$(lsb_release -cs) && \
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \	
    	tee /etc/apt/sources.list.d/azure-cli.list && \
	curl https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb > packages-microsoft-prod.deb && \
	dpkg -i packages-microsoft-prod.deb && \
	rm packages-microsoft-prod.deb && \
	apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
      apt-transport-https \
      azure-cli \
	    dotnet-sdk-3.1 \
	    aspnetcore-runtime-3.1 \
	    azure-functions-core-tools && \
	  rm -rf /var/lib/apt/lists/*
