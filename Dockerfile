## Base image
FROM ubuntu:22.04


## Build arguments
ARG DEBIAN_FRONTEND=noninteractive


## Setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime


## Install some packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    gnupg2 \
    lsb-release \
    software-properties-common \
    wget


## Add APT remotes
# CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"

## Install dependencies
RUN apt-get update && \
    apt-get install -y \
    cmake \
    cmake-curses-gui \
    dirmngr \
    dotnet-sdk-8.0 \
    git \
    jq \
    libgtest-dev \
    make \
    nano \
    ninja-build \
    python3-pip \
    rsync \
    sed \
    sudo \
    vim \
    wget \
    zsh


##  Install compiler alternatives
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 18 all

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 18
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 18
RUN update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 18
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-18 18
RUN update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-18 18

# Set compiler environment variables
ENV CC="/usr/bin/clang"
ENV CXX="/usr/bin/clang++"
ENV CMAKE_GENERATOR="Ninja"



## Manage user
# Options
ARG USER_NAME=3laws

# Create user
RUN useradd -ms /bin/bash $USER_NAME
RUN echo "$USER_NAME:$USER_NAME" | chpasswd

# Remove need for password with sudo command
RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME

# Add user to sudo and root groups
RUN usermod -aG sudo $USER_NAME
RUN usermod -aG root $USER_NAME

# Switch to user
USER $USER_NAME
ENV HOME=/home/$USER_NAME
WORKDIR $HOME
RUN touch ".sudo_as_admin_successful"


##  Install and configure conan
RUN pip install conan && . ~/.profile && conan && conan profile detect


##  Install misc tools
RUN pip install black cpplint cmake-format
