---
date: 2024-09-21 16:20
description: Use xcrun simctl to free some disk space
tags: ios, xcode, command-line
---
# How to remove unused simulator runtimes

If you want to free some disk space by removing unused, unsupported or obsolete iOS simulator runtimes, you can first use the `xcrun` subcommand dedicated to managing simulators, `simctl`, to detect which runtime to delete:

```no-highlight
xcrun simctl runtime list
```

The ouput will look like the following:

```no-highlight
== Disk Images ==
-- iOS --
iOS 18.0 (22A3351) - 7976B5EC-52B8-4B7E-AF55-EC026BD24B51 (Ready)
iOS 17.5 (21F79) - 9591EEC3-598B-48AC-986D-53CEAB6FEBDB (Ready)
iOS 15.4 (19E240) - 5E844228-D8DF-4662-8D0E-9F3D1B898FAC (Ready)
iOS 16.4 (20E247) - 2671D0D4-24FF-4DAB-B148-C6C3547621E2 (Ready)
-- tvOS --
tvOS 18.0 (22J356) - F9F3744E-EDB7-4849-AFAB-21F103AA404A (Ready)
-- xrOS --
xrOS 2.0 (22N318) - A3675326-E2E5-4CEA-B0C9-68930F3E3317 (Ready)

Total Disk Images: 6 (32.1G)
```

Once you've decided which runtime has to go, you can use the `delete <identifier>` subcommand.
For instance, when your app stops supporting iOS 15, you can remove its simulator runtime with :

```no-highlight
xcrun simctl runtime delete 19E240
```

You can even use the `all` alias to delete all images :

```no-highlight
xcrun simctl runtime delete all
```

or add an option to only delete images not used within the past `<days>` days :

```no-highlight
xcrun simctl runtime delete --notUsedSinceDays 365
```

Finally, you can test your command before actually executing it, by appending `--dry-run`.

Thus, typing this command:

```no-highlight
xcrun simctl runtime delete all --dry-run
```

would provide that output:

```no-highlight
Would delete D: A3675326-E2E5-4CEA-B0C9-68930F3E3317 xrOS (2.0 - 22N318) (Ready)
Would delete B: D5E22916-F2E6-48C4-8FD3-6C8F07FC0646 iOS (15.4 - 19E240) (Ready)
Would delete D: 7976B5EC-52B8-4B7E-AF55-EC026BD24B51 iOS (18.0 - 22A3351) (Ready)
Would delete D: 9591EEC3-598B-48AC-986D-53CEAB6FEBDB iOS (17.5 - 21F79) (Ready)
Would delete D: 2671D0D4-24FF-4DAB-B148-C6C3547621E2 iOS (16.4 - 20E247) (Ready)
Would delete D: F9F3744E-EDB7-4849-AFAB-21F103AA404A tvOS (18.0 - 22J356) (Ready)
```