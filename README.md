# **Setting Up a Nexus Node**

You earn NEX points based on your contributions

---

## **Minimum Requirements:**
RAM: 12GB

ROM: 20GB

CPU CORES: 6 CORES

---

  ### ✅ Method 1: One-Line Automated Setup
  
  For a quick and seamless setup, run the following command in your terminal:
  
  ```bash
  curl -fsSL https://raw.githubusercontent.com/phaul1/nexus-setup/refs/heads/main/nexus-setup.sh | bash
```

This command will:

- Stop and remove existing Nexus processes

- Remove all previous configurations and dependencies

- Install Rust, Nexus CLI, and necessary dependencies properly

- Set up the Nexus node

- Start the node inside a screen session for stability

- Accept terms when prompted

- Choose option 2 and enter your Node ID when prompted

- To reconnect to the running node session, use:

 ```bash
screen -r nexus
```


## To link to your Node to Nexus Account

Create an account at https://app.nexus.xyz.

Click ``Node`` then click ``+ Add Node`` then click ``Add CLI Node``

Copy Node ID and Paste it in CLI when prompted

---

### ⚙️ Method 2: Manual Setup

## **Step 1: Remove All Nexus-Related Files and Configurations**

Before reinstalling, ensure all existing Nexus-related processes are stopped.

```bash
pkill nexus
pkill orchestrator
pkill prover
```

This will terminate any running Nexus-related processes.

---

## **Step 2: Remove All Nexus-Related Files and Configurations**

To completely reset your setup, delete all previous installations, dependencies, and configurations.

```bash
rm -rf $HOME/.nexus
rm -rf $HOME/.cargo/registry/src/github.com-*/stwo-*
rm -rf $HOME/.cargo/git/checkouts/stwo-*
rm -rf $HOME/.rustup
rm -rf $HOME/.cargo
```

This ensures that any corrupted or outdated files are removed.

---

## **Step 3: Install Updates and Dependencies**

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen curl libssl-dev pkg-config git build-essential
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protoc-21.12-linux-x86_64.zip
ls -lh protoc-21.12-linux-x86_64.zip
unzip protoc-21.12-linux-x86_64.zip -d $HOME/.local
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

## **Step 4: Reinstall Rust Properly & Add riscv32i target**
Now, install Rust properly to ensure compatibility with Nexus CLI.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup default stable
rustup component add rust-src
rustup target add riscv32i-unknown-none-elf

```

Verify the installation:

```bash
rustc --version
cargo --version
```

This should output the installed versions of Rust and Cargo.

---

## **Step 5: Install Nexus CLI and Dependencies**

### **Option 1: Standard Installation**
Try the standard installation first:

```bash
curl -fsSL https://cli.nexus.xyz/ | sh
```

If it is installed properly, you will be asked to accept their policy and provide your Node ID

If this fails, proceed to the manual installation.

### **Alternatively: Option 2**
If the standard installation fails, manually download and install Nexus CLI.

```bash
mkdir -p $HOME/.nexus/bin
cd $HOME/.nexus/bin
wget https://cli.nexus.xyz/latest/nexus-cli-linux-amd64 -O nexus-cli
chmod +x nexus-cli
export PATH=$HOME/.nexus/bin:$PATH
echo 'export PATH=$HOME/.nexus/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Verify the installation:

```bash
nexus-cli start
```

---

## **Step 6: Set Up Your Nexus Node**
After installing Nexus CLI, set up your node with your Node ID

If you encounter the error **"Invalid setup option selected"**, try running:

```bash
nexus-cli node setup --manual
```

Follow the on-screen instructions to complete the setup.

You are now running a fresh and properly configured Nexus node.

---

## **Conclusion**
This helps completely reset and reinstall processes to fix common issues with Nexus CLI and node setup. If you continue to experience problems, check the official Nexus documentation or community support for further troubleshooting.

---
