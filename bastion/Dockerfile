FROM debian:jessie

RUN apt-get update \
    && apt-get install -y traceroute \
                          curl \
                          dnsutils \
                          netcat-openbsd \
                          jq \
                          nmap \ 
                          net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY Dockerfile /Dockerfile

LABEL org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.vcs-type="Git" \
      org.label-schema.vcs-url="https://github.com/amouat/network-utils-container"
     
ENTRYPOINT ["tail", "-f", "/dev/null"]