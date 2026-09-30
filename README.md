# 📋 Task Manager CLI

A minimalist command-line task management tool written in Lua, designed for quick local tracking without the bloat of heavy task apps.

---

## 🚀 Features

* **Quick Add:** Append tasks directly from the terminal.
* **Status Toggle:** Mark items as completed, pending, or in progress.
* **List View:** Formatted terminal overview of active tasks.
* **Persistent Storage:** Saves tasks locally across terminal sessions.

---

## 🛠 Tech Stack

* **Language:** [Lua](https://www.lua.org/)
* **Environment:** Terminal / Bash

---

📦 Getting Started
Prerequisites

Ensure you have Lua installed on your machine

Installation

Clone the repository and run:

```bash

git clone [https://github.com/your-username/task-manager-cli.git](https://github.com/your-username/task-manager-cli.git)
cd task-manager-cli
lua main.lua

``

## 📥 Global Installation (Add to PATH)

To run `taskapp` from anywhere in your terminal without typing `lua path/to/main.lua`:

### Method 1: Local User (Recommended)

1. Make the script executable:
   ```bash
   chmod +x TaskApp
``` 
Symlink it into your local binary directory (usually already in your $PATH):
``` 
mkdir -p ~/.local/bin
ln -sf "$(pwd)/TaskApp" ~/.local/bin/taskapp
```  
Ensure ~/.local/bin is in your $PATH (if not already):

```
# Add to ~/.bashrc or ~/.zshrc if needed:
export PATH="$HOME/.local/bin:$PATH"
```
Now reload your shell (source ~/.bashrc or open a new terminal) and run:
```
task <command1> <parameters> 
```  
## 💻 Usage

Run the script using the Lua runtime followed by the desired command (If installed in PATH, just run "task" without "lua" or "TaskApp.lua"):

```bash
# List all tasks
lua TaskApp.lua list

# Add a new task
lua TaskApp.lua add "Finish Lua API project" 2026-08-12

# Mark a task as complete
lua TaskApp.lua finished <id> (coming soon)

# Remove a task
lua TaskApp.lua delete <id>

# Remove all
lua TaskApp.lua removeall

``` 

🗺️ Roadmap & WIP

    [x] Basic task creation and deletion

    [x] Task listing and status updates

    [x] Local state persistence

    [ ] Implement -h / --help flag for CLI usage instructions

    [ ] Priority tags or filter flags

