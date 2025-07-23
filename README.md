# 🧠 copy_code

![Gem Version](https://img.shields.io/gem/v/copy_code.svg)
![Ruby](https://img.shields.io/badge/ruby-3.0%2B-red)
![License](https://img.shields.io/github/license/t0nylombardi/copy_code)
![Build Status](https://img.shields.io/github/actions/workflow/status/t0nylombardi/copy_code/test.yml?branch=main)
![Code Style](https://img.shields.io/badge/code%20style-rubocop-brightgreen)

A smart, flexible CLI tool to copy source code from a directory (or project) into your clipboard or a text file — while skipping unnecessary files using `.ccignore`.

---

## 🔧 Features

- ✅ Recursively finds source code files in a target directory
- 🧹 Ignores folders like `.git`, `node_modules`, etc. using a `.copy_codeignore` file
- 🎯 Filters by file extension (`--extensions=rb,py,js`)
- 📋 Copies output to your clipboard or saves to a file (`--print=pbcopy|txt`)
- 🐚 Works from the terminal with one clean command

---

## 🚀 Installation

```sh
gem install copy_code
```

Or clone and build manually:

```sh
git clone https://github.com/your_username/copy_code.git
cd copy_code
gem build copy_code.gemspec
gem install ./copy_code-*.gem
```

## 🛠 Usage

```sh
copy_code [options] [paths]
```

### Examples

Copy all .rb and .py files from the current directory and subdirectories:

```sh
copy_code -e rb,py
```

Copy .js, .ts, and .json files from a specific folder and write to a file:

```sh
copy_code ~/projects/my-app -e js,ts,json -p txt
```

Copy all .rb and .py files from the current directory and subdirectories:

```sh
copy_code -e rb,py
```

Copy .js, .ts, and .json files from a specific folder and write to a file:

```sh
copy_code ~/projects/my-app -e js,ts,json -p txt
```

```sh
copy_code -e rb,py
```

Copy .js, .ts, and .json files from a specific folder and write to a file:

```sh
copy_code ~/projects/my-app -e js,ts,json -p txt
```

```sh
copy_code -e rb,py
```

### 📂 .ccignore

You can create a `.ccignore` file in your project directory to specify files and directories to ignore. This works similarly to `.gitignore`.

### Example `.ccignore` file

```
# Ignore all node_modules directories
node_modules/
# Ignore all .git directories
.git/
# Ignore all log files
*.log
# Ignore all temporary files
*.tmp
# Ignore all coverage directories
coverage/
# Ignore all virtual environments
.venv/
```

### Options

| flags                | options                                                              |
| -------------------- | -------------------------------------------------------------------- |
| -e, --extensions=EXT | Comma-separated list of file extensions to include (e.g. `-e rb,py`) |
| -p, --print=OUT      | Output format: `pbcopy` (clipboard) or `txt` (file)                  |
| -h                   | Show help information                                                |

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
