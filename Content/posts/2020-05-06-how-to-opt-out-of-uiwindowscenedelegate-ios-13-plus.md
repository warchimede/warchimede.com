---
date: 2020-05-06 17:30
description: When you need to support older iOS versions
tags: ios, swift
---
# How to opt out of `UIWindowSceneDelegate` on iOS 13+

When you create a new Xcode project that will support more versions than just iOS 13, you have to get rid of all the code related to the `UIWindowSceneDelegate` protocol, and more.
Here are the few steps to follow.

## 1. Obviously, set the deployment target

In the **General** > **Deployment Info** section of the settings of your target, set the minimal required iOS version.

You won't be able to build your project at this point.

## 2. Delete the `Application Scene Manifest` entry from your **Info.plist**

## 3. Delete `SceneDelegate.swift`

## 4. Update `AppDelegate.swift`

First, remove the following chunk of code:

```swift
// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  // Called when the user discards a scene session.
  // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
  // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
```

Then, add the `window` property to your `AppDelegate`:

```swift
var window: UIWindow?
```

## 5. Enjoy watching your project build properly
