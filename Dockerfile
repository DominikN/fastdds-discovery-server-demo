FROM ros:galactic

# Use bash instead of sh for the RUN steps
SHELL ["/bin/bash", "-c"]

# Install ros packages and dependencies
RUN apt-get update && apt-get install -y \
    # Fast DDS dependencies
    libssl-dev \
    libasio-dev \
    # Demo packages
    ros-${ROS_DISTRO}-demo-nodes-cpp

# Build Fast DDS and rmw_fastrtps from sources. This is because specifying IP addresses using names
# is only supported in Fast DDS v2.4.0 and onwards, but ROS 2 Galactic binary installation ships
# Fast DDS v2.3.4. Since Fast DDS v2.3.4 and v2.4.0 are not binary compatible, the three packages
# rmw_fastrtps_shared_cpp, rmw_fastrtps_cpp, and rmw_fastrtps_dynamic_cpp need to be built as well.
# The rmw_fastrtps_* packages are contained in the rmw_fastrtps repository, for which Galactic ships
# 5.0.0, which is what is built here. If this project is upgraded to ROS 2 Humble, all this can be
# removed, as Humble will ship Fast DDS v2.6.0, and in fact rmw_fastrtps_cpp will be the default
# rmw implementation, so it will be already installed in the ros:humble Docker image.
WORKDIR /fastdds_overlay
COPY fastdds.repos colcon.meta /fastdds_overlay/
RUN source /opt/ros/galactic/setup.bash && \
    # Download sources
    mkdir src && \
    vcs import src < fastdds.repos && \
    # Install rmw_fastrtps_cpp dependencies without installing ros-galactic-rmw-fastrtps-cpp
    sed -i 's/ros-'$ROS_DISTRO'-rmw-cyclonedds-cpp | ros-'$ROS_DISTRO'-rmw-connextdds | ros-'$ROS_DISTRO'-rmw-fastrtps-cpp/ros-'$ROS_DISTRO'-rmw-dds-common/' /var/lib/dpkg/status && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    # Build overlay
    colcon build && \
    # Cleanup
    apt autoremove -y && \
    rm -rf log/ build/ src/ colcon.meta fastdds.repos && \
    rm -rf /var/lib/apt/lists/*

COPY fastdds_server.xml /
COPY fastdds_client.xml /
