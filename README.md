# What is this

This script converts a Google Keep archive to markdown.
(Especially, this script is intended for Obsidian's markdown format.)

# How to Use

## 1. Download Google Keep File
From this page:
https://takeout.google.com/

This script uses the downloaded JSON.

## 2. Download This Repository

## 3. Excute command

```bash
cd
ruby exec.rb <target dir> <output_dir> <number of files: for test>

# example
# ruby exec.rb keep_memos/Keep/ output_folder/ 100000
```

# Features
This script makes `attachments/` directory under `ouput_floder/`.

It saves audio files and image files.

# LICENSE
LGPL-3.0

https://opensource.org/licenses/LGPL-3.0
https://licenses.opensource.jp/LGPL-3.0/LGPL-3.0.html

## Additional Licensing Information
Copying a portion of this code does not constitute a modification.

If you modify the code for a similar purpose (such as converting one type to another), we recommend that you publish it as a modification, although it is not mandatory.

If you can create a better script based on this one, I would be glad to hear from you.
