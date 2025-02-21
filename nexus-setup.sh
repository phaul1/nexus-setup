#!/bin/bash

set -e  # Exit immediately if any command fails

# Stop and Remove Existing Nexus Processes
echo "Stopping any running Nexus processes..."
pkill nexus || true
pkill orchestrator || true
pkill prover || true

# Remove All Nexus-Related Files and Configurations
echo "Removing old Nexus installations and dependencies..."
rm -rf $HOME/.nexus
rm -rf $HOME/.cargo/registry/src/github.com-*/stwo-*
rm -rf $HOME/.cargo/git/checkouts/stwo-*
rm -rf $HOME/.rustup
rm -rf $HOME/.cargo

# Update system and install dependencies (excluding protobuf-compiler, since we'll install a specific version)
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl libssl-dev pkg-config git build-essential

# Download and install protoc v21.12 from GitHub
echo "Downloading and installing protoc v21.12..."
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protoc-21.12-linux-x86_64.zip
ls -lh protoc-21.12-linux-x86_64.zip
unzip -o protoc-21.12-linux-x86_64.zip -d $HOME/.local
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install Rust Properly
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default stable
rustup component add rust-src
rustup target add riscv32i-unknown-none-elf

# Verify Rust installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

# Start a detached screen session named 'nexus'
echo "Starting a detached screen session 'nexus'..."
screen -S nexus -dm

# Install Nexus CLI
echo "Installing Nexus CLI..."
if curl -fsSL https://cli.nexus.xyz/ | sh; then
    echo "Standard installation succeeded."
else
    echo "Standard installation failed. Killing existing screen session and proceeding with manual installation..."
    screen -S nexus -X quit || true
    mkdir -p $HOME/.nexus/bin
    cd $HOME/.nexus/bin
    wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli
    chmod +x nexus-cli
    export PATH=$HOME/.nexus/bin:$PATH
    echo 'export PATH=$HOME/.nexus/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
fi

# Verify Nexus CLI installation
echo "Verifying Nexus CLI installation..."
nexus-cli --version

# Setup the Nexus Node
echo "Setting up Nexus node..."
nexus-cli node setup || nexus-cli node setup --manual

# Start the Nexus Node inside the existing screen session
echo "Starting Nexus node in the screen session..."
screen -S nexus -X stuff "nexus-cli node start$(printf '\r')"

echo "Nexus node setup complete! Run 'screen -r nexus' to view the session."
