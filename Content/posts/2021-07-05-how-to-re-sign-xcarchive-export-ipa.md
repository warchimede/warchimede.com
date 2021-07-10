---
date: 2021-07-09 20:00
description: When you ask for an apple pie and you get lemonade, use PlistBuddy and codesign
tags: ios, command-line
---
# How to re-sign an `.xcarchive` and export to `.ipa` for App Store submission

I often need to submit for review on App Store Connect app projects coming from external contractors.

I am usually given `.xcarchive`s which bundle identifiers, version numbers and codesigning need to be updated. 😅

Here is a step-by-step guide explaining how I proceed. 🤓

> Suggestions are welcome and greatly appreciated, hit me up on [Twitter](https://twitter.com/warchimede). 🐥

## 0️⃣ Extract the `.app` from the `.xcarchive`

All the necessary work will be done with or within the `.app`, thus it is easier to create a working directory and extract it there right away :

```no-highlight
cp -r ARCHIVE.xcarchive/Products/Applications/APP.app .
```

## 1️⃣ Update the bundle identifier

Now we need to start updating the app's `Info.plist`, so let's use the right tool for the job, aka `PlistBuddy` : 🔧

```no-highlight
# update the app
/usr/libexec/PlistBuddy APP.app/Info.plist -c "set :CFBundleIdentifier APP_BUNDLE_ID"

# and each extension accordingly
/usr/libexec/PlistBuddy APP.app/PlugIns/EXTENSION.appex/Info.plist -c "set :CFBundleIdentifier EXTENSION_BUNDLE_ID"
```

## 2️⃣ Extract the entitlements

Before re-signing the app, we need to update its entitlements.

Let's get these sneaky bastards thanks to `codesign` : ✍️

```no-highlight
# app's entitlements
codesign -d --entitlements :- APP.app > APP_ENTITLEMENTS.plist

# extensions' entitlements
codesign -d --entitlements :- APP.app/PlugIns/EXTENSION.appex > EXTENSION_ENTITLEMENTS.plist
```

## 3️⃣ Update the entitlements data

Again, call `PlistBuddy` to the rescue !

> This time, we will use several `PlistBuddy` commands in a row for the entitlements update. Instead of using `-c` to execute one change at a time, we will load the `.plist` with the tool, tell it each task we want it to execute, then `save` the `.plist` and `exit` when we are done.

```no-highlight
# update app's entitlements
/usr/libexec/PlistBuddy APP_ENTITLEMENT.plist
set :application-identifier TEAM_ID.APP_BUNDLE_ID
set :com.apple.developer.team-identifier TEAM_ID
set :keychain-access-groups:0 TEAM_ID.APP_BUNDLE_ID
save
exit

# and extensions' entitlements accordingly
/usr/libexec/PlistBuddy EXTENSION_ENTITLEMENT.plist
set :application-identifier TEAM_ID.EXTENSION_BUNDLE_ID
set :com.apple.developer.team-identifier TEAM_ID
set :keychain-access-groups:0 TEAM_ID.EXTENSION_BUNDLE_ID
save
exit
```

## 4️⃣ Remove the code signature

It is time to destroy the current codesigning by fire. 🔥

```no-highlight
rm -rf APP.app/_CodeSignature
rm -rf APP.app/Frameworks/*/_CodeSignature
rm -rf APP.app/PlugIns/*.appex/_CodeSignature
```

## 5️⃣ Replace the provisioning profiles

The last step before signing is to put the proper provisioning profiles in the app and its extensions :

```no-highlight
cp APP_PROFILE.mobileprovision APP.app/embedded.mobileprovision

cp EXTENSION_PROFILE.mobileprovision APP.app/PlugIns/EXTENSION.appex/embedded.mobileprovision
```

## 6️⃣ Sign the `.app`

🚨 Be careful, **respect this exact order** when using `codesign` to re-sign the app :

```no-highlight
# first, frameworks
codesign -f -s "Apple Distribution: CERTIFICATE" APP.app/Frameworks/*

# then, extensions
codesign -f -s "Apple Distribution: CERTIFICATE" --entitlements EXTENSION_ENTITLEMENTS.plist APP.app/PlugIns/EXTENSION.appex

# finally, the app
codesign -f -s "Apple Distribution: CERTIFICATE" --entitlements APP_ENTITLEMENTS.plist APP.app
```

## 7️⃣ Create the `.ipa` 🎁

Last but not least, make the `.ipa` for your newly signed `.app` :

```no-highlight
# some scaffolding first
mkdir output
mkdir output/Payload

# deliver the payload
mv APP.app output/Payload/

# 🚨 do not forget to copy the SwiftSupport directory from the xcarchive
cp -r ARCHIVE.xcarchive/SwiftSupport output/

# wrap everything nicely
cd output
zip -qr APP.ipa .
```

## 8️⃣ Submit the app for review 🤞🏽