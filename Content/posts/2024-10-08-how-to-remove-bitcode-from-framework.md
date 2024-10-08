---
date: 2024-10-08 22:00
description: Use xcrun bitcode_strip
tags: ios, xcode, command-line
---
# How to remove bitcode from a framework

When trying to upload your app to **App Store Connect** using **Xcode 16**, you may encounter the following error :

> 🛑 **Asset validation failed**

> Invalid Executable. The executable 'YourApp.app/Frameworks/Foobar.framework/Foobar' contains bitcode.

Indeed, [Xcode 15 Release note](https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes/#Deprecations) was already mentioning that bitcode was not supported anymore :

> **Deprecations**

> Bitcode support has been removed, and the ENABLE_BITCODE build setting no longer has any effect.

Thus, in order to be able to submit your new app version to Apple while still depending on the `Foobar` framework, you can use the dedicated `xcrun` subcommand named `bitcode_strip` :

```no-highlight
xcrun bitcode_strip -r Foobar.framework/Foobar -o Foobar.framework/Foobar
```

According to `man bitcode_strip`, the `-r` option removes the `__LLVM` bitcode segment entirely, which is exactly what you want, and `-o` specifies the output file.

Now, let's say `Foobar.xcframework` is a third party dependency and you retrieve it via `cocoapods`, you may then want to add the following to your `Podfile` to remove bitcode after the dependency is installed :

```ruby
post_install do |installer|
  project = installer.pods_project
  # ⚠️ paths may vary from a project to another
  $work_path = "#{project.path}/.."
  project.pods.children.each do |pod|
    # Target Foobar's pod
    if pod.name == 'Foobar'
      $xcframework_path = "#{$work_path}/#{pod.path}/Foobar.xcframework"
      # Iterate over every framework slice of the xcframework
      Dir.glob("#{$xcframework_path}/*/Foobar.framework").each do |framework|
        # Strip bitcode
        %x(xcrun bitcode_strip -r #{framework}/Foobar -o #{framework}/Foobar)
      end
    end
  end
end
```