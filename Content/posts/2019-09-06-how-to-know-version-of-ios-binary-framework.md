---
date: 2019-09-06 17:30
description: PlistBuddy is your friend
tags: ios, xcode, command-line
---
# How to know the version of an iOS binary framework

Either check the `Info.plist` file included in the framework, or use `PlistBuddy`.

## The `PlistBuddy` way

> `PlistBuddy` is a built-in command line tool in macOS for `.plist` editing purposes.

Use the following command to display the `Bundle Short Version` of `StuffManager.framework` for instance:
```no-highlight
/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "StuffManager.framework/Info.plist"
```
The output should be similar to:
```no-highlight
6.31.0
```
