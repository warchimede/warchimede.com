---
date: 2017-10-05 17:30
description: More plist, please
tags: xcode, ios, command-line
---
# Export `.xcarchive` to `.ipa` using `xcodebuild` for manually signed projects

## The generic command

By now, if you are used to export a previously generated `.xcarchive` to  `.ipa` using `xcodebuild` command line tool, you should be familiar with the following command :
```no-highlight
xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH} \
-exportPath ${EXPORT_PATH} \
-exportOptionsPlist ${EXPORT_OPTIONS_PLIST_PATH}.plist
```

The `-exportOptionsPlist` option is mandatory here, so you have to provide your own `.plist` file containing - you guessed it - the options for exporting  your archive.

## Before Xcode 9

The only required option was the export method : `app-store`, `ad-hoc`, `enterprise` or `development`.

Thus, your `.plist` file would look like the following :

```no-highlight
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>enterprise</string>
</dict>
</plist>
```

And that was it 🤓.

## From now on

If you try to run the command with this `.plist` after you upgraded to Xcode 9, `xcodebuild` will *sometimes* answer with a `Segmentation fault: 11`.

Very nice, thank you ! 💩💀🖕< * *Goes on breaking things...* * >

Whoa, let’s keep our composure, please. What is going on here ?

### Getting rid of the segmentation fault

After investigation, this came up while reading `xcodebuild --help` :

> compileBitcode : Bool

> For non-App Store exports, should Xcode re-compile the app from bitcode? Defaults to YES.

It seems that the flag `compileBitcode` being set to `true` by default, makes the whole thing fall apart. The solution is then to explicitly add the flag to the `.plist` and set it to `false` :

```no-highlight
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>compileBitcode</key>
    <false/>
    <key>method</key>
    <string>enterprise</string>
</dict>
</plist>
```

Let’s run the command again…💥🔥

Okay, the segmentation fault is gone, but now `xcodebuild` says : 

`error: exportArchive: "YourAppName.app" requires a provisioning profile.`

Apparently, `xcodebuild` needs more options in the `.plist` regarding provisioning.

### Adding provisioning information

A new export option called `provisioningProfiles` is available :

> provisioningProfiles : Dictionary

> For manual signing only. Specify the provisioning profile to use for each executable in your app. Keys in this dictionary are the bundle identifiers of executables; values are the provisioning profile name or UUID to use.

Since the app is manually signed (as opposed to automatically managed by Xcode), you need to add this option to your `.plist`.

### Resulting `.plist`

You should now be fine with the following :

```no-highlight
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>compileBitcode</key>
    <false/>
    <key>method</key>
    <string>enterprise</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>your.bundle.identifier</key>
        <string>Provisioning profile name</string>
    </dict>
</dict>
</plist>
```
