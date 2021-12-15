# fastdds-discovery-server-demo

Using [Fast DDS Discovery Server](https://docs.ros.org/en/foxy/Tutorials/Discovery-Server/Discovery-Server.html) with multiple hosts connected over the Internet with Husarnet p2p VPN. 

[![Build a Docker Image](https://github.com/DominikN/fastdds-discovery-server-demo/actions/workflows/build_push.yaml/badge.svg)](https://github.com/DominikN/fastdds-discovery-server-demo/actions/workflows/build_push.yaml)
[![Test a Docker Deployment](https://github.com/DominikN/fastdds-discovery-server-demo/actions/workflows/test.yaml/badge.svg)](https://github.com/DominikN/fastdds-discovery-server-demo/actions/workflows/test.yaml)

## Intro

According to the docs: *the Fast DDS Discovery Server protocol is a feature that offers a centralized dynamic discovery mechanism, as opposed to the distributed mechanism used in DDS by default.*

This feature is especially important for ROS 2 devices that are not connected to the same WiFi router, and thus multicasting (used for a standard DDS discovery) is not efficient enough, not convenient or even is not possible.

This repo presents **how to use FastDDS Discovery Server in a ROS 2 talker/listener demo**. Each device can be in different network, and **public IP is not required**.

The Discovery Server is used only during a service discovery phase. The actual messages are forwarded with minimal latency between devices thanks to [Husarnet peer-to-peer VPN](https://github.com/husarnet/husarnet).

## Get your Husarnet Join Code

Before running examples get your **Husarnet Join Code**. You will use it to connect Docker containers to the same VPN network.

At first rename `.env.template` file to `.env`.

You will find your Join Code at **https://app.husarnet.com  
 -> Click on the desired network  
 -> `Add element` button  
 -> `Join code` tab**

…and change the `JOINCODE` variable in the `.env` files.

## Get the `ros:galactic` image with `Fast DDS v2.4.0`

Fast DDS is not a default RMW in ROS 2 Galactic. Also *hostnames* for DDS Discovery Server in Fast DDS `.xml` files **are not supported in versions < `v2.4.0`** that are available in the package repository (installed with `apt-get install ros-${ROS_DISTRO}-rmw-fastrtps-cpp`). 

This is why we need to build a new Docker Image based on `ros:galactic` with `Fast DDS v2.4.0` built from source.

### Docker registry (`ARM64` and `AMD64`)

Building `Fast DDS v2.4.0` from source takes a while (especially for `ARM64`) so you can use a prebuild image from this repo:

```bash
docker pull ghcr.io/dominikn/ros-galactic-fastdds:v2.4.0
```

### Local build

If you want to build your own image, modify all `docker-compose.*.yml` files in the repo by replacing line ...

```yml 
image: ghcr.io/dominikn/ros-galactic-fastdds:v2.4.0
```

with ...

```yml
build: ./docker_image
```

## Deployment

Prepare 3 devices (eg. laptop, Raspberry Pi etc.) with Docker and Docker-Compose installed. They could be in the same, or in different Ethernet/WiFi/LTE networks.

> **💡 Tip**
>
> You can also run those 3 Docker Compose deployments on one laptop if you don't want to test it over the Internet

In this demo we will deploy different `docker.compose.yml` files on different devices:

- **DDS Discovery Server** launched by `docker-compose.discovery-server.yml`
- **Listener** (from [demo-nodes-cpp](https://github.com/ros2/demos/tree/master/demo_nodes_cpp) ROS 2 package) launched by `docker-compose.listener.yml`
- **Talker** (from [demo-nodes-cpp](https://github.com/ros2/demos/tree/master/demo_nodes_cpp) ROS 2 package) launched by `docker-compose.talker.yml`

### DDS Discovery Server

```bash
docker-compose -f docker-compose.discovery-server.yml up
```

### Listener

```bash
docker-compose -f docker-compose.listener.yml up
```

### Talker

```bash
docker-compose -f docker-compose.talker.yml up
```

## Result

Eg. log from a `listener` deployment:

```
Creating fastdds-discovery-server-demo_husarnet-listener_1 ... done
Creating fastdds-discovery-server-demo_listener_1          ... done
Attaching to fastdds-discovery-server-demo_husarnet-listener_1, fastdds-discovery-server-demo_listener_1
husarnet-listener_1  | [step 1/3] Waiting for Husarnet daemon to start
husarnet-listener_1  | ...
listener_1           | Waiting for "ddsdiscoveryserver" host to be available in /etc/hosts
husarnet-listener_1  | done
husarnet-listener_1  | 
husarnet-listener_1  | [step 2/3] Waiting for Base Server connection
husarnet-listener_1  | ...
husarnet-listener_1  | ...
husarnet-listener_1  | ...
husarnet-listener_1  | done
husarnet-listener_1  | 
husarnet-listener_1  | [step 3/3] Joining to Husarnet network
husarnet-listener_1  | [113550] joining...
husarnet-listener_1  | [115551] joining...
husarnet-listener_1  | [117552] done.
husarnet-listener_1  | Husarnet IP address: fc94:2d06:2252:4c24:f214:815e:fc13:5703
listener_1           | "ddsdiscoveryserver" present in /etc/hosts:
listener_1           | fc94:3087:c846:f00b:5649:4d19:9436:a1a4 ddsdiscoveryserver # managed by Husarnet
listener_1           | [INFO] [1639526642.398818137] [listener]: I heard: [Hello World: 2]
listener_1           | [INFO] [1639526643.396153300] [listener]: I heard: [Hello World: 3]
listener_1           | [INFO] [1639526644.395698379] [listener]: I heard: [Hello World: 4]
listener_1           | [INFO] [1639526645.320585014] [listener]: I heard: [Hello World: 5]
listener_1           | [INFO] [1639526646.305184684] [listener]: I heard: [Hello World: 6]
```