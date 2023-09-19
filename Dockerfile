FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04
RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates libjpeg-dev libpng-dev && rm -rf /var/lib/apt/lists/* # buildkit
# COPY /opt/conda /opt/conda # buildkit
ENV PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PYTORCH_VERSION=v1.10.0
# ssh
RUN apt-get -y install openssh-server
COPY ./sshd_config /etc/ssh/sshd_config
RUN chmod 644 /etc/ssh/sshd_config
RUN echo "jjchen7434\njjchen7434" | passwd
RUN echo PATH='"'${PATH}'"' > /etc/environment
# git
RUN apt-get install -y git
# python env
RUN pip install matplotlib
RUN pip install jupyterlab
RUN pip install jupyterlab-git
RUN pip install tensorboard
RUN jupyter lab --generate-config
ENV PASSWORD=jjc123
ENV SHELL=/bin/bash
# set localtime
WORKDIR /root/.init
COPY setting .
RUN cp localtime /etc
RUN rm localtime
WORKDIR /workspace
CMD python /root/.init/setting.py && service ssh start && jupyter lab --ip 0.0.0.0 --no-browser --allow-root

# cd /home/hawk/docker_files/pytorch1.10.0_ssh
# sudo docker build -t 4159sh/pytorch:1.10.0-jupyterlab-ssh .