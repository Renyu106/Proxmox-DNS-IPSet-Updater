# 🔄 Proxmox DNS IPSet Updater

Automatically updates Proxmox firewall IPSet entries by synchronizing DNS records with IP addresses

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📝 Overview

This script automatically manages Proxmox firewall IPSet entries by monitoring and updating IP addresses based on DNS resolution. Perfect for environments where target IP addresses change dynamically.

## ✨ Features

- 🔄 Automatic DNS resolution and IPSet updates
- 🏷️ Comment-based tracking with DNS information
- 🎯 Custom DNS server support
- ⚡ Efficient updates (only when IP changes detected)

## 🔧 Requirements

- 🖥️ Proxmox VE environment
- 📦 `jq` command-line JSON processor
- 🌐 `dig` DNS lookup utility
- 🔑 Proper permissions to modify Proxmox firewall rules

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/Renyu106/Proxmox-DNS-IPSet-Updater.git
```

2. Make the script executable:
```bash
chmod +x dns-ipset-updater.sh
```

## ⚙️ Configuration

Edit the following variables in the script:

```bash
readonly DNS_SERVER="1.1.1.1"        # Your preferred DNS server
readonly IPSET_NAME="servers"        # Your IPSet name
readonly DNS_PREFIX="AutoDNS|"       # Prefix for managed entries
```

## 📋 Usage

1. Add DNS entries to your IPSet with the specified prefix:
```bash
pvesh create /cluster/firewall/ipset/${IPSET_NAME} -cidr "1.2.3.4/32" -comment "AutoDNS|example.com"
```

2. Run the script:
```bash
./dns-ipset-updater.sh
```

## 🔄 Automation

To automate updates, add a cron job:

```bash
# Run every hour
0 * * * * /path/to/dns-ipset-updater.sh
```

## 📝 Example Output

```
Processing DNS: example.com (Current IP: 1.2.3.4/32)
Resolved IP: 5.6.7.8
IP changed for example.com (1.2.3.4/32 -> 5.6.7.8)
Removing old IP: 1.2.3.4/32
Adding new IP: 5.6.7.8/32
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🛠️ Submit pull requests

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
