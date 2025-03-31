FROM almalinux:9.5-20250307

# Install tools and dependencies
RUN dnf update -y \
    && dnf group install -y "Development Tools" \
    && dnf install -y glibc-langpack-en sudo tzdata \
    && dnf install -y cmake llvm-toolset wopenssl-devel procps-ng python3.11 python3.11-pip \
    && dnf install -y dnf-plugins-core && dnf config-manager --set-enabled crb \
    && dnf install -y glibc-static \
    && dnf install -y epel-release \
    && dnf install -y tidy
RUN alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2 && \
    alternatives --set python3 /usr/bin/python3.11 && \
    ln -sf /usr/bin/pip3.11 /usr/bin/pip3

# Create and switch to user
ARG USERNAME="rust"
ARG USER_UID="1000"
RUN useradd -m -s /bin/bash -u $USER_UID $USERNAME \
    && mkdir -p /etc/sudoers.d \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# Install Rust with nightly-2025-01-03 toolchain (required by Buck2)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly-2025-01-03 -y
ENV PATH="/home/$USERNAME/.cargo/bin:$PATH"

# Install Buck2 and Reindeer
RUN cargo install --git https://github.com/facebook/buck2.git --rev 8c3ed01 buck2
RUN cargo install --git https://github.com/facebookincubator/reindeer.git --rev 2a8cc41 reindeer

# Create and set permissions for workdir directory and other directories
USER root
RUN mkdir -p /workdir && chown $USERNAME:$USERNAME /workdir
USER $USERNAME

WORKDIR /workdir

ENV TZ=Asia/Shanghai
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
