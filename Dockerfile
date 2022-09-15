FROM ubuntu:20.04

ARG HOME=/root

# 0. Install general tools
ARG DEBIAN_FRONTEND=noninteractive

# python3=3.8.2-0ubuntu2: python3 3.8.10
# hadolint ignore=DL3008,DL3009,DL3015
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    neovim \
    python3=3.8.2-0ubuntu2 \
    python3-pip \
    tmux

# Install pip dependencies
# hadolint ignore=DL3013,DL3008
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --upgrade setuptools \
    && pip install --no-cache-dir \
    numpy \
    pandas \
    matplotlib



# Clean up  the cache of apt
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Set up Rust
# - https://learningos.github.io/rust-based-os-comp2022/0setup-devel-env.html#qemu
# - https://www.rust-lang.org/tools/install
# - https://github.com/rust-lang/docker-rust/blob/master/Dockerfile-debian.template

# Install
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=nightly
RUN set -eux; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME;

# Sanity checking
RUN rustup --version && \
    cargo --version && \
    rustc --version

# Build env for labs
RUN rustup component add clippy rustfmt rust-src

# Ready to go
WORKDIR ${HOME}/code
