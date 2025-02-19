Setting Up a Nexus Node

Overview

This guide provides two methods to set up a Nexus node from scratch. The first method is a fully automated one-liner script for ease of use, while the second method offers a manual step-by-step approach.

Method 1: One-Line Automated Setup

For a quick and seamless setup, run the following command in your terminal:

curl -fsSL https://raw.githubusercontent.com/phaul1/nexus-setup/refs/heads/main/nexus-setup.sh | bash

This command will:

Stop and remove existing Nexus processes

Remove all previous configurations and dependencies

Install Rust and Nexus CLI properly

Set up the Nexus node

Start the node inside a screen session for stability

Accept terms when prompted

Choose option 2 and enter your Node ID when prompted

To reconnect to the running node session, use:

screen -r nexus

Method 2: Manual Setup

Step 1: Stop and Remove Existing Nexus Processes

pkill nexus || true
pkill orchestrator || true
pkill prover || true

Step 2: Remove All Nexus-Related Files and Configurations

rm -rf $HOME/.nexus
rm -rf $HOME/.cargo/registry/src/github.com-*/stwo-*
rm -rf $HOME/.cargo/git/checkouts/stwo-*
rm -rf $HOME/.rustup
rm -rf $HOME/.cargo

Step 3: Install Rust

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup default nightly
rustup component add rust-src --toolchain nightly

Step 4: Install Nexus CLI

Try Standard Installation First

curl -fsSL https://cli.nexus.xyz/ | sh
export PATH=$HOME/.nexus/bin:$PATH
source ~/.bashrc

If Standard Installation Fails, Use Manual Installation

mkdir -p $HOME/.nexus/bin
cd $HOME/.nexus/bin
wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli
chmod +x nexus-cli
export PATH=$HOME/.nexus/bin:$PATH
echo 'export PATH=$HOME/.nexus/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

Step 5: Set Up Your Node

nexus-cli node setup || nexus-cli node setup --manual

Step 6: Start Node in a Screen Session

screen -dmS nexus nexus-cli node start

To reconnect later, run:

screen -r nexus

Conclusion

Using the automated method ensures a quick and error-free setup, while the manual approach provides deeper control. Choose the method that suits your preference.

For further assistance, check the official Nexus documentation or community support channels.
