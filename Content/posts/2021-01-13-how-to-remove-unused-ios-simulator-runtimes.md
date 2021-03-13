---
date: 2021-01-13 17:30
description: Use xcrun simctl to free some disk space
tags: ios, xcode, command-line
---
# How to remove unused iOS simulator runtimes

If you want to free some disk space by removing unused, unsupported or obsolete iOS simulator runtimes, you can first use the `xcrun` subcommand dedicated to managing simulators, `simctl`, to detect which runtime to delete:

```no-highlight
xcrun simctl list runtimes
```

The ouput will look like the following:

```no-highlight
== Runtimes ==
iOS 9.3 (9.3 - 13E233) - com.apple.CoreSimulator.SimRuntime.iOS-9-3 (unavailable, The iOS 9.3 simulator runtime is not supported on hosts after macOS 10.14.99.)
iOS 10.3 (10.3.1 - 14E8301) - com.apple.CoreSimulator.SimRuntime.iOS-10-3 (unavailable, The iOS 10.3 simulator runtime is not supported on hosts after macOS 10.15.99.)
iOS 11.4 (11.4 - 15F79) - com.apple.CoreSimulator.SimRuntime.iOS-11-4
iOS 12.4 (12.4 - 16G73) - com.apple.CoreSimulator.SimRuntime.iOS-12-4
iOS 13.5 (13.5 - 17F61) - com.apple.CoreSimulator.SimRuntime.iOS-13-5
iOS 14.3 (14.3 - 18C61) - com.apple.CoreSimulator.SimRuntime.iOS-14-3
tvOS 13.4 (13.4 - 17L255) - com.apple.CoreSimulator.SimRuntime.tvOS-13-4
tvOS 14.3 (14.3 - 18K559) - com.apple.CoreSimulator.SimRuntime.tvOS-14-3
watchOS 7.2 (7.2 - 18S561) - com.apple.CoreSimulator.SimRuntime.watchOS-7-2
```

As you can see, both `9.3` and `10.3` runtimes are unsupported by macOS Big Sur.
Now, go to `/Library/Developer/CoreSimulator/Profiles/Runtimes` and delete the files named `iOS 9.3.simruntime` and `iOS 10.3.simruntime`.