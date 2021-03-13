---
date: 2019-09-05 17:30
description: lipo to the rescue
tags: ios, xcode, command-line
---
# How to know which architectures are included in an iOS binary framework

Use the the `lipo` command with the `-info` or `-i` option (example using StuffManager.framework):
```no-highlight
lipo -info StuffManager.framework/StuffManager
```
The output will be something like this:
```no-highlight
Non-fat file: StuffManager.framework/StuffManager is architecture: arm64
```
or
```no-highlight
Architectures in the fat file: StuffManager.framework/StuffManager are: x86_64 arm64
```
