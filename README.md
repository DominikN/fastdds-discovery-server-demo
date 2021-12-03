# fastdds-discovery-server-demo

Using FastDDS discovery server over the Internet with VPN.

## Get your Husarnet JoinCode

Before running examples get your Husarnet Join Code, that you will use to connect Docker containers to the same P2P VPN network.

At first rename `.env.template` files to `.env`.

You will find your Join Code at **https://app.husarnet.com  
 -> Click on the desired network  
 -> `Add element` button  
 -> `Join code` tab**

…and change the `JOINCODE` variable in the `.env` files

## Launching `ddsdiscoveryserver` device

```bash
docker-compose -f docker-compose.discovery-server.yml up
```

The output will look like:

```bash
$ docker-compose -f docker-compose.discovery-server.yml up
Starting 3_discovery_server_demo_husarnet-discovery-server_1 ... done
Starting 3_discovery_server_demo_discovery-server_1          ... done
Attaching to 3_discovery_server_demo_husarnet-discovery-server_1, 3_discovery_server_demo_discovery-server_1
husarnet-discovery-server_1  | Waiting for the husarnet daemon to start
husarnet-discovery-server_1  | [6130668] joining...
husarnet-discovery-server_1  | [6132669] joining...
husarnet-discovery-server_1  | [6134670] joining...
husarnet-discovery-server_1  | [6136671] joining...
husarnet-discovery-server_1  | [6138672] joining...
husarnet-discovery-server_1  | [6140673] joining...
husarnet-discovery-server_1  | [6142674] joining...
husarnet-discovery-server_1  | Husarnet IP address: fc94:cecc:3189:ae23:cc06:7b07:50fe:e0e9
```

Shut down container ([`ctrl` + `c`]) and copy the given IPv6 address to `fastdds_client.xml` and `fastdds_server.xml` files in that section:

```xml
<metatrafficUnicastLocatorList>
    <locator>
        <udpv6>
            <address>PLACE_IPV6_ADDR_OF_DISCOVERY_SERVER_HERE</address>
            <port>11811</port>
        </udpv6>
    </locator>
</metatrafficUnicastLocatorList>
```

Now restart `DDS discovery server container`:

```bash
docker-compose -f docker-compose.discovery-server.yml up
```

## Launching `listener` device

```bash
docker-compose -f docker-compose.listener.yml up
```

## Launching `talker` device

```bash
docker-compose -f docker-compose.talker.yml up
```
