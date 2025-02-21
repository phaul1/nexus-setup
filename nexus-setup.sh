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
sudo apt install -y screen curl libssl-dev pkg-config git build-essential

# Download and install protoc v21.12 from GitHub (overwrite existing files)
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

# Start a detached screen session named 'nexus' that will handle Nexus CLI installation and node startup
echo "Starting a screen session 'nexus' for Nexus CLI installation and node startup..."
screen -R nexus -X quit 2>/dev/null  # Ensure no existing session is running
screen -dmS nexus bash  # Start a new detached screen session
screen -R nexus  # Attach to the screen session (so you're inside before installation starts)

# Now everything runs inside the screen session:
screen -S nexus -X stuff $'echo "Installing Nexus CLI..."\n'
screen -S nexus -X stuff $'if curl -fsSL https://cli.nexus.xyz/ | sh; then\n'
screen -S nexus -X stuff $'  echo "Standard installation succeeded."\n'
screen -S nexus -X stuff $'else\n'
screen -S nexus -X stuff $'  echo "Standard installation failed. Proceeding with manual installation..."\n'
screen -S nexus -X stuff $'  mkdir -p $HOME/.nexus/bin\n'
screen -S nexus -X stuff $'  cd $HOME/.nexus/bin\n'
screen -S nexus -X stuff $'  wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli\n'
screen -S nexus -X stuff $'  chmod +x nexus-cli\n'
screen -S nexus -X stuff $'  export PATH=$HOME/.nexus/bin:$PATH\n'
screen -S nexus -X stuff $'  echo "export PATH=$HOME/.nexus/bin:$PATH" >> ~/.bashrc\n'
screen -S nexus -X stuff $'  source ~/.bashrc\n'
screen -S nexus -X stuff $'fi\n'
screen -S nexus -X stuff $'echo "Verifying Nexus CLI installation..."\n'
screen -S nexus -X stuff $'nexus-cli --version\n'
screen -S nexus -X stuff $'echo "Setting up Nexus node..."\n'
screen -S nexus -X stuff $'nexus-cli node setup || nexus-cli node setup --manual\n'
screen -S nexus -X stuff $'echo "Starting Nexus node..."\n'
screen -S nexus -X stuff $'nexus-cli node start\n'
screen -S nexus -X stuff $'exec bash\n'
'

echo "Nexus node setup initiated in screen session 'nexus'."
echo "To view the session, run: screen -r nexus"
