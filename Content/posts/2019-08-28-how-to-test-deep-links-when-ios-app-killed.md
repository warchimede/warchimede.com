---
date: 2019-08-28 17:30
description: Use simctl
tags: ios, xcode, command-line
---
# How to test deep links when an iOS app is killed

## Configure the app scheme

1. Navigate to the scheme for the project in Xcode.
2. Under the `Run` section's `Info` tab, there is a `Launch` radio button.
3. Make sure `Wait for executable to be launched` instead of `Automatically`.

## Run the app

Run the app from Xcode. It will not open on the device / simulator, as the debugger will wait for it to open and then will attach to its process.

## Test deep link using `simctl`, a `xcrun` subcommand

Open your terminal and use this command: `xcrun simctl openurl booted [http://yourdomain/path]`.
It should open your app on the device / simulator.

Breakpoints are supported for debugging purposes.

## Issues so far

- `NSLog` / `print` statements might not output to the console, so if no breakpoint is set, it would appear as though the debugger had not attached to the app at all.
