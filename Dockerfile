FROM debian:jessie-20190708-slim

# Add Perforce packaging key
ADD https://package.perforce.com/perforce.pubkey /tmp/perforce.pubkey
RUN apt-key add /tmp/perforce.pubkey

# Add Perforce repository
RUN echo "deb http://package.perforce.com/apt/ubuntu precise release" > /etc/apt/sources.list.d/perforce.list

# Install Perforce server components
RUN apt-get update && apt-get install -y helix-p4d=2019.1-*~precise

# Expose default Perforce port.
EXPOSE 1666

# Setup Env Variables. 
ENV P4HOST=localhost \
    P4ROOT=/root/perforceDB/ \
    P4PORT=1666

RUN mkdir $P4ROOT

# Start the server
CMD ["p4d", "-r", "/root/perforceDB"]
