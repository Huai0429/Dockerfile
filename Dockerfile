FROM pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime
RUN apt-get update
COPY /usr/local/cuda /usr/local/
RUN export PATH=/usr/local/cuda/bin:$PATH
RUN export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
# ssh
RUN apt-get install openssh-server -y
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