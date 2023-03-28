#######################config http for docker#####################
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo vi /etc/systemd/system/docker.service.d/http-proxy.conf
sudo systemctl daemon-reload
sudo systemctl restart docker
systemctl show docker --property Environment
########################docker#######################
docker pull image #download image from dockerhub
docker run image ls # run commands in new continer from image..for each operation run will found new contianer isolated
docker exec -it contianer-id /bin/bash # run commands in running continer
docker diff continer-id # A for add, C for change , D for Delete
docker system prune #remove image safe

#create image from container after update to contianer
docker commit container-id
docker image tag id-image e2e:v1 # rename id-image to e2e:v2
##in one line
docker commit -m "install figlet" contianer-id e2e:v1
#history image
docker history image-id # info about layers that build image
docker inspect --format="{{json .RootFS.Layers}}" image-id #show layers that make up the image
docker inspect --format="{{range.NetworkSettings.Networks}}{.IPAddress}}{{end}}" contianer-id # ip netword continaer
docker inspect nginx 
docker stats contianer-id # status cpu memory for continer
##enable buildkit
vi /etc/docker/deamon.json
add => { "features": { "buildkit": true } }
sudo systemctl daemon-reload
sudo systemctl restart docker

#docker network 
docker network ls
docker inspect bridge
docker network create --driver bridge n1
docker inspect n1
docker run -it --network n1 --name e18 -d ubuntu:20.04
docker network create --driver bridge n2
docker inspect n2
docker run -it --network n2 --name e19 -d ubuntu:20.04
#disconnet and connect between network and continer
docker network disconnect n2 e19
docker inspect n2
docker network connect n1 e20
docker inspect n1
#copy from continer to host
sudo docker cp continer-id:path/to/contianer path/to/host
#run script
docker run -it --rm --name testpython -v "$PWD:/usr/src" -w "/usr/src" python:3.8 python tmp.py

#remove exited using -f status and pass all id using -q 
docker rm $(docker ps -a -f status=exited -q)

#remove images none after stop or delete container
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)


#build image from Dockerfile
docker build -t image:tag .
#run continer from image
docker run --name name_continer -d -t image:tag
#run continer and debug
docker run --name name_continer -d -t image:tag tail -f /dev/null #or
docker run --name name_continer -d -t image:tag sleep infinity


#practical
docker build -t board:v1
docker run -it --name test -v ${PWD}:/code -p 9000:8000 -d board:v1 # two way binding
docker run -it --name test -v ${PWD}:/code:ro -p 9000:8000 -d board:v1 #one way binding using add read_only(ro)
docker run -it --name test -v ${PWD}:/code:ro -v /src/node_moudls -p 9000:8000 -d board:v1 #one way binding using add read_only(ro) and protect node_moudls
docker run -it --name test -v ${PWD}/src:/code/src:ro -p 9000:8000 -d board:v1 # simplest
docker run -it --name test -v ${PWD}/src:/code/src:ro -p 9000:8000 --env-file ./.env -d board:v1 # simplest