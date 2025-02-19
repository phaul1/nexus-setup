#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

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

# Update system and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl libssl-dev pkg-config build-essential protobuf-compiler

# Install Rust Properly
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default nightly
rustup component add rust-src --toolchain nightly

# Verify Rust installation
echo "Verifying Rust installation..."
rustc --version
cargo --version

# Install Nexus CLI
echo "Installing Nexus CLI..."
curl -fsSL https://cli.nexus.xyz/ | sh || {
    echo "Standard installation failed. Proceeding with manual installation..."
    mkdir -p $HOME/.nexus/bin
    cd $HOME/.nexus/bin
    wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli
    chmod +x nexus-cli
    export PATH=$HOME/.nexus/bin:$PATH
    echo 'export PATH=$HOME/.nexus/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
}

# Verify Nexus CLI installation
echo "Verifying Nexus CLI installation..."
nexus-cli --version

# Setup the Nexus Node
echo "Setting up Nexus node..."
nexus-cli node setup || nexus-cli node setup --manual

# Start the Nexus Node inside a screen session
echo "Starting Nexus node in a screen session..."
screen -dmS nexus nexus-cli node start

echo "Nexus node setup complete! Run 'screen -r nexus' to view the session."
