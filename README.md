# fastdds-discovery-server-demo

Using [FastDDS Discovery Server](https://docs.ros.org/en/foxy/Tutorials/Discovery-Server/Discovery-Server.html) over the Internet with VPN.

## Intro

According to the docs: *the Fast DDS Discovery Server protocol is a feature that offers a centralized dynamic discovery mechanism, as opposed to the distributed mechanism used in DDS by default.*

This feature is especially important for ROS 2 devices that are not connected to the same WiFi router, and thus multicasting (used for a standard DDS discovery) is not efficient enough, not convenient or even is not possible.

This repo presents how to use the Discovery Server in a ROS 2 talker/listener demo. Each device can be in different network, and public IP is not required.

The Discovery Server is used only for a service discovery phase. The actual messages are forwarded p2p between devices thanks to [Husarnet VPN](https://github.com/husarnet/husarnet).

## Get your Husarnet Join Code

Before running examples get your **Husarnet Join Code**, that you will use to connect Docker containers to the same P2P VPN network.

At first rename `.env.template` files to `.env`.

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
docker pull ghcr.io/dominikn/ros-galactic-fastdds-v240
```

### Local build

If you want to build your own image, modify all `docker-compose.*.yml` files in the repo by replacing line ...

```yml 
image: ghcr.io/dominikn/ros-galactic-fastdds-v240
```

with ...

```yml
build: ./docker_image
```

## Deployment

Prepare 3 devices (laptop, Raspberry Pi etc.) with Docker and Docker-Compose installed. They could be in the same, or in different Ethernet/WiFi/LTE networks.

> **💡 Tip**
> You can also run those three Docker Compose deployments on one laptop if you don't want to test it over the Internet

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
