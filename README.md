# 🧠 copy_code

![Gem Version](https://img.shields.io/gem/v/copy_code.svg?color=209fb5)
![Ruby](https://img.shields.io/badge/ruby-3.2%2B-e64553.svg)
![Build Status](https://img.shields.io/github/actions/workflow/status/t0nylombardi/copy_code/test.yml?branch=main&color=a6da95)
![Code Style](https://img.shields.io/badge/code%20style-standardrb-c6a0f6.svg)

A smart, flexible CLI tool to copy source code from a directory (or project) into your clipboard or a text file — while skipping unnecessary files using `.ccignore`.

---

## 🔧 Features

- ✅ Recursively finds source code files in a target directory
- 🧹 Ignores folders like `.git`, `node_modules`, etc. using a `.copy_codeignore` file
- 🎯 Filters by file extension (`--extensions=rb,py,js`)
- 📋 Copies output to your clipboard or saves to a file (`--print=pbcopy|txt`)
- 🐚 Works from the terminal with one clean command

---

### Options

| flags                | options                                                              |
| -------------------- | -------------------------------------------------------------------- |
| -e, --extensions=EXT | Comma-separated list of file extensions to include (e.g. `-e rb,py`) |
| -p, --print=OUT      | Output format: `pbcopy` (clipboard) or `txt` (file)                  |
| -o, --output-path=PATH | Output path or directory for `txt` mode (default: `code_output.txt`) |
| -h                   | Show help information                                                |

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

Write output to a specific file:

```sh
copy_code ~/projects/my-app -e rb -p txt -o ~/tmp/my_code.txt
```

Write output to the project root:

```sh
copy_code ~/projects/my-app -e rb -p txt -o .
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

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
