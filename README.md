# fastdds-discovery-server-demo

Using [Fast DDS Discovery Server](https://docs.ros.org/en/foxy/Tutorials/Discovery-Server/Discovery-Server.html) with multiple hosts connected over the Internet with Husarnet p2p VPN. 

[![Build a Docker Image](https://github.com/DominikN/ros-galactic-fastdds/actions/workflows/build_push.yaml/badge.svg)](https://github.com/DominikN/ros-galactic-fastdds/actions/workflows/build_push.yaml)
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

…and change the `HUSARNET_JOINCODE` variable in the `.env` files.

## Get the `ros:galactic` image with `Fast DDS v2.4.0`

Fast DDS is not a default RMW in ROS 2 Galactic. Also *hostnames* for DDS Discovery Server in Fast DDS `.xml` files **are not supported in versions < `v2.4.0`** that are available in the package repository (installed with `apt-get install ros-${ROS_DISTRO}-rmw-fastrtps-cpp`). 

This is why we need to build a new Docker Image based on `ros:galactic` with `Fast DDS v2.4.0` built from source.

### Docker registry (`ARM64` and `AMD64`)

Building `Fast DDS v2.4.0` from source takes a while (especially for `ARM64`) so you can use a prebuild image from this repo:

```bash
docker pull ghcr.io/dominikn/ros-galactic-fastdds:v2.4.0
```

### Local build

The Docker image is built from this repo: https://github.com/DominikN/ros-galactic-fastdds.

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
docker compose -f compose.discovery-server.yaml up
```

### Listener

```bash
docker compose -f compose.listener.yaml up
```

### Talker

```bash
docker compose -f compose.talker.yaml up
```

## Result

Eg. log from a `listener` deployment:

```
Status: Downloaded newer image for ghcr.io/dominikn/ros-galactic-fastdds:v2.4.0
Creating fastdds-discovery-server-demo_husarnet-listener_1 ... done
Creating fastdds-discovery-server-demo_listener_1          ... done
Attaching to fastdds-discovery-server-demo_husarnet-listener_1, fastdds-discovery-server-demo_listener_1
husarnet-listener_1  | [step 1/3] Waiting for Husarnet daemon to start
husarnet-listener_1  | ...
husarnet-listener_1  | done
husarnet-listener_1  | 
husarnet-listener_1  | [step 2/3] Waiting for Base Server connection
husarnet-listener_1  | ...
listener_1           | Waiting for "dds-discovery-server" host to be available in /etc/hosts
husarnet-listener_1  | ...
husarnet-listener_1  | ...
husarnet-listener_1  | done
husarnet-listener_1  | 
husarnet-listener_1  | [step 3/3] Joining to Husarnet network
husarnet-listener_1  | [85082] joining...
husarnet-listener_1  | [87083] joining...
husarnet-listener_1  | [89083] done.
husarnet-listener_1  | Husarnet IP address: fc94:2c41:e14f:842b:c456:8ab6:915d:2866
listener_1           | "dds-discovery-server" present in /etc/hosts:
listener_1           | fc94:acec:4daf:30b6:f28b:1f9a:f683:0638 dds-discovery-server # managed by Husarnet
listener_1           | Ready to launch ROS 2 nodes
listener_1           | [INFO] [1639528088.384928610] [listener]: I heard: [Hello World: 2]
listener_1           | [INFO] [1639528089.385449769] [listener]: I heard: [Hello World: 3]
listener_1           | [INFO] [1639528090.384367537] [listener]: I heard: [Hello World: 4]
```