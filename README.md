title: "Setting Up a Nexus Node"
overview: |
  This guide provides two methods to set up a Nexus node from scratch.
  
---

method1: |
  ## ✅ Method 1: One-Line Automated Setup
  
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
