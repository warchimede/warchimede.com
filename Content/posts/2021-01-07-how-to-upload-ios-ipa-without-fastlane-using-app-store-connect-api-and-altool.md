---
date: 2021-01-07 17:30
description: fastlane not needed, altool for the win
tags: ios, xcode, command-line
---
# How to easily upload an iOS `.ipa` from the command line without `fastlane`, using the App Store Connect API and `altool`

## Generate the App Store Connect API private key

According to the [official Apple documentation](https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api):

> To generate keys, you must have an Admin account in App Store Connect. You may generate multiple API keys with any roles you choose.

> 1. To generate an API key to use with the App Store Connect API, log in to App Store Connect.

> 2. Select Users and Access, and then select the API Keys tab.

> 3. Click Generate API Key or the Add (+) button.

> 4. Enter a name for the key. The name is for your reference only and is not part of the key itself.

> 5. Under Access, select the role for the key.

> 6. Click Generate.

> 7. The new key's name, key ID, a download link, and other information appears on the page.


Name you key `App Store Connect API key`, download it and persist it somewhere safe.
It should be a `AuthKey_<key_id>.p8` file.

Also, remember the key identifier and your `Issuer ID` for later use.

## Store the key at the right location

Then, store a copy of your private API key under the path `~/.appstoreconnect/private_keys/`.
This step is very important for `altool` to locate your API key.

## Use `altool`, the `xcrun` subcommand replacing Application Loader

You can now use the following to upload your `.ipa` to App Store Connect:

```no-highlight
xcrun altool --upload-app -f <PATH_TO_IPA>.ipa --apiKey <KEY_ID> --apiIssuer <ISSUER_ID>
```

## Make it a script for simpler use

Open a new file named `upload_ipa.sh` and paste the following:

```no-highlight
#!/bin/bash

echo "Uploading IPA to App Store Connect"
xcrun altool --upload-app -f $1 \
  --apiKey <KEY_ID> \
  --apiIssuer <ISSUER_ID>
```

Save the file somewhere handy, and make it executable with this command:

```no-highlight
chmod +x upload_ipa.sh
```

## Use the script

Finally, you can upload your freshly built `.ipa` to App Store Connect with your brand new script:

```no-highlight
./upload_ipa.sh <PATH_TO_IPA>.ipa
```