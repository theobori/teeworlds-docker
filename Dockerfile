FROM ubuntu:20.04

# Working directory
ENV DIRNAME tw

# Avoid tz stuck at installation
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow

# Install dependencies to build binaries
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install build-essential \
    cmake \
    git \
    libfreetype6-dev \
    libsdl2-dev \
    libpnglite-dev \
    libwavpack-dev \
    python3

# Clone the git repository
RUN git clone https://github.com/teeworlds/teeworlds --recurse-submodules $DIRNAME

WORKDIR $DIRNAME

# Compile client only
RUN mkdir -p build && \
    cd build && \
    cmake .. && \
    make teeworlds

# Not working if running the executable outside the build directory
WORKDIR build

ENTRYPOINT [ "./teeworlds"]
