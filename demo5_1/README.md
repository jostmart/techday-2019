### Cygate Techdays 2019
Ansible automation demo for Cygate Techdays 2019 by Christofer Tibbelin

## Ansible Demo 5.1 :whale::ballot_box_with_check::point_up:

### Build a [Docker](https://www.docker.com/) container and install Check Points API software in it.

> in this demo my Docker host is the same as Ansible host running Ubuntu 18.10
> Docker is already installed

#### Create docker group and add user to this group. ReInit group.
> So we don't need to sudo for docker jobs on the docker host
```sh
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
```

#### install docker python on your docker host. (same as my ansible host)
> so ansible can talk to this. I had problems with python2 so had to run python3 in the inventory
```sh
pip install docker
```

#### Create a dockerfile with the [CheckPoint MGT API](https://github.com/CheckPointSW/cp_mgmt_api_python_sdk) in a empty folder (I call this folder docker)
> This is what Ansible will start to create docker image
```dockerfile
# Download base image from python repository version 3.7-alpine
# Alpine is extra small image
FROM python:3.7-alpine
MAINTAINER FullName <email@Address>
# use apk to update + install git
RUN apk add --update git
# Install CheckPoint MGT API to talk to CheckPoint MGT server
RUN pip install git+https://github.com/CheckPointSW/cp_mgmt_api_python_sdk
#Keep container running Fake as we use docker connection to reach it.
ENTRYPOINT ["tail", "-f", "/dev/null"]
```

### Two choices here. either use Ansible to deploy docker container or do it via console.
#### For Ansible deploy only do:
```sh
ansible-playbook -i inventory.ini create_docker.yml
```

#### Otherwise do all commands below:
#### Create docker network
```sh
docker network list | grep -q "mgt_net" || docker network create "mgt_net"
```

#### Build docker image from the dockerfile in the local catalog docker
> tag is the same as name
```sh
docker build --tag=cp_api-img ./docker/
```

#### Start the Docker container and name it cp_api01
> cp_api-img is the image name/tag from previous command.
```sh
docker run -d -P \
  --network='mgt_net' \
  --network-alias mgt \
  --name cp_api01 cp_api-img
```

### Both Ansible and Commandline version can check from here
#### check if container is running + diskSize
```sh
docker ps -s --format "table {{.Names}}: {{.Size}}: {{.RunningFor}}"
```

#### Optional: Check memory usage & cpu
```sh
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

#### Optional: logon to the container with shell
```sh
docker exec -it cp_api01 sh
```

### [Demo 5.2](../demo5_2/) :whale::ballot_box_with_check::metal:
Use the new Ansible module and docker container to push a change to the [CheckPoint](https://www.checkpoint.com/) MGT
