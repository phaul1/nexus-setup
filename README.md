title: "Setting Up a Nexus Node"
overview: >
  This guide provides two methods to set up a Nexus node from scratch.
  
---
methods:
  - name: "Method 1: One-Line Automated Setup"
    description: "For a quick and seamless setup, run the following command in your terminal:"
    command: |
      curl -fsSL https://raw.githubusercontent.com/phaul1/nexus-setup/refs/heads/main/nexus-setup.sh | bash
    details: |
      This command will:
      - Stop and remove existing Nexus processes
      - Remove all previous configurations and dependencies
      - Install Rust, Nexus CLI, and necessary dependencies properly
      - Set up the Nexus node
      - Start the node inside a `screen` session for stability
      - Accept terms when prompted
      - Choose **option 2** and enter your **Node ID** when prompted
      
      To reconnect to the running node session, use:
      
      screen -r nexus

  - name: "Method 2: Manual Setup"
    steps:
      - step: "Step 1: Stop and Remove Existing Nexus Processes"
        command: |
          pkill nexus || true
          pkill orchestrator || true
          pkill prover || true
      - step: "Step 2: Remove All Nexus-Related Files and Configurations"
        command: |
          rm -rf $HOME/.nexus
          rm -rf $HOME/.cargo/registry/src/github.com-/stwo-
          rm -rf $HOME/.cargo/git/checkouts/stwo-*
          rm -rf $HOME/.rustup
          rm -rf $HOME/.cargo
      - step: "Step 3: Install Rust and Dependencies"
        command: |
          sudo apt update && sudo apt install -y screen curl libssl-dev pkg-config build-essential protobuf-compiler
          curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
          source $HOME/.cargo/env
          rustup default nightly
          rustup component add rust-src --toolchain nightly
      - step: "Step 4: Install Nexus CLI (Standard Installation)"
        command: |
          curl -fsSL https://cli.nexus.xyz/ | sh
          export PATH=$HOME/.nexus/bin:$PATH
          source ~/.bashrc
      - step: "Step 4 (Alternate): Manual Installation of Nexus CLI"
        command: |
          mkdir -p $HOME/.nexus/bin
          cd $HOME/.nexus/bin
          wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli
          chmod +x nexus-cli
          export PATH=$HOME/.nexus/bin:$PATH
          echo 'export PATH=$HOME/.nexus/bin:$PATH' >> ~/.bashrc
          source ~/.bashrc
      - step: "Step 5: Set Up Your Node"
        command: |
          nexus-cli node setup || nexus-cli node setup --manual
      - step: "Step 6: Start Node in a Screen Session"
        command: |
          screen -dmS nexus nexus-cli node start
          # To reconnect later, run:
          screen -r nexus
conclusion: >
  Using the automated method ensures a quick and error-free setup, while the manual approach provides deeper control.  
  Choose the method that suits your preference.  
  For further assistance, check the official Nexus documentation or community support channels.
