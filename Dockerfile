FROM ros:galactic

# install ros package
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-rmw-fastrtps-cpp \
    ros-${ROS_DISTRO}-demo-nodes-py && \
    rm -rf /var/lib/apt/lists/*

COPY fastdds_server.xml /
COPY fastdds_client.xml /