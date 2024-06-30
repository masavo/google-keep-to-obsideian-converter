# What is this?
This script convert GoogleKeep archive to markdown.
(especially this script is for obsidian's markdown file)

# how to use

## 1. Download GoogleKeep file
from this page
https://takeout.google.com/

This script use the downloaded json.

## 2. Download this repository

## 3. Excute command

```bash
cd
ruby exec.rb <target dir> <output_dir> <number of files: for test>

# example
# ruby exec.rb keep_memos/Keep/ output_folder/ 100000
```

# Features
This script make `attachments/` directory under `ouput_floder/`.

It save audio files and image files.

# LISENCE
LGPL-3.0

https://opensource.org/licenses/LGPL-3.0
https://licenses.opensource.jp/LGPL-3.0/LGPL-3.0.html

## Additional Licensing Information
 partial copy of a portion of this code is not called a modification.

 If you modify the code for a similar purpose (converting some type to some type), we recommend that you publish it as a modification, but you do not have to do so.

If you can make a better script based on this script, I would be glad to hear from you.
