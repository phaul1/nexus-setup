title: "Setting Up a Nexus Node"

You earn NEX points based on your contributions
 
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

Create an account at app.nexus.xyz.

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

## **Step 3: Reinstall Rust Properly**
Now, install Rust properly to ensure compatibility with Nexus CLI.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup default nightly
rustup component add rust-src --toolchain nightly
```

Verify the installation:

```bash
rustc --version
cargo --version
```

This should output the installed versions of Rust and Cargo.

---

## **Step 4: Install Nexus CLI and Dependencies**

### **Option 1: Standard Installation (May Fail Due to Errors)**
Try the standard installation first:

```bash
curl -fsSL https://cli.nexus.xyz/ | sh
export PATH=$HOME/.nexus/bin:$PATH
source ~/.bashrc
```

Check if Nexus CLI is installed correctly:

```bash
nexus-cli --version
```

If the command is not found, proceed to the manual installation.

### **Option 2: Manual Installation of Nexus CLI**
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
nexus-cli --version
```

---

## **Step 5: Set Up Your Nexus Node**
After installing Nexus CLI, set up your node.

```bash
nexus-cli node setup
```

If you encounter the error **"Invalid setup option selected"**, try running:

```bash
nexus-cli node setup --manual
```

Follow the on-screen instructions to complete the setup.

---

## **Step 6: Verify and Start Your Node**
Once the setup is complete, verify your node status:

```bash
nexus-cli node status
```

If everything is set up correctly, start your node:

```bash
nexus-cli node start
```

You are now running a fresh and properly configured Nexus node.

---

## **Conclusion**
This guide provides a complete reset and reinstall process to fix common issues with Nexus CLI and node setup. If you continue to experience problems, check the official Nexus documentation or community support for further troubleshooting.

---
