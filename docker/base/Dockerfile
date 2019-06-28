FROM python

RUN apt update -y && \
    apt install groff less -y && \
    pip install -U ansible boto3 botocore awscli  && \
    useradd -Ums /bin/bash -d /ansible ansible && \
    chown -R ansible:ansible /ansible

WORKDIR /ansible
USER ansible
VOLUME [ "/ansible" ]
