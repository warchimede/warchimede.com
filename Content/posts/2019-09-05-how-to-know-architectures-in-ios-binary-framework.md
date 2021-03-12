---
date: 2019-09-05 17:30
description:
tags: ios, xcode, command-line
---
# How to know which architectures are included in an iOS binary framework

Use the the `lipo` command with the `-info` or `-i` option (example using StuffManager.framework):
```sh
lipo -info StuffManager.framework/StuffManager
```
The output will be something like this:
```sh
Non-fat file: StuffManager.framework/StuffManager is architecture: arm64
```
or
```sh
Architectures in the fat file: StuffManager.framework/StuffManager are: x86_64 arm64
```
