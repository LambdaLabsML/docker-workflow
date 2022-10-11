ARG ngc_image_tag
FROM nvcr.io/nvidia/pytorch:$ngc_image_tag

RUN mkdir /workload

RUN cd /workload && git clone https://github.com/LambdaLabsML/examples.git && git checkout f8585bc0b9ed043134b7e27820924838c98ccb62 && cd ..

RUN apt-get update && apt install -y openssh-client openssh-server

WORKDIR /workload

# Allow OpenSSH to talk to containers without asking for confirmation
RUN mkdir -p /var/run/sshd
RUN echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    sed -i 's/#\(StrictModes \).*/\1no/g' /etc/ssh/sshd_config

# Copy lauch script
COPY ./ngc/pytorch/runai/launcher-script.sh /usr/bin
RUN chmod a+x /usr/bin/launcher-script.sh
