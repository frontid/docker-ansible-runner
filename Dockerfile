FROM alpine

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/community" >> /etc/apk/repositories; echo "http://dl-cdn.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories

# Bash terminal
RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN \
  apk --update add \
  python \
  python-dev \
  py-pip \
  build-base \
  ansible \
  rsync \
  openssh \
  && pip install virtualenv \
  && pip install jmespath \
  && rm -rf /var/cache/apk/*

# Ansible config storage
RUN mkdir /etc/ansible/ /ansible

RUN mkdir -p /ansible/files
RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart

# Avoid Host hey checking: http://docs.ansible.com/ansible/intro_getting_started.html#host-key-checking: Not best to do
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
# This is set in configuration
# ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles 
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

#ENTRYPOINT ["ansible-playbook"]
CMD tail -f /dev/null
