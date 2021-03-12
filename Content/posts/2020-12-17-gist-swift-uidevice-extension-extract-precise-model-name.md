---
date: 2020-12-17 17:30
description: Use a mirror for reflection
tags: ios, swift
---
# Gist: Swift `UIDevice` extension allowing to extract more precise model name from system information

```swift
import Foundation

extension UIDevice {
  public var modelName: String {
    var systemInfo = utsname()

    guard uname(&systemInfo) == 0 else { return model }

    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let bytes = machineMirror.children
      .compactMap({ $0.value as? Int8 })
      .filter({ $0 != 0 })
      .compactMap({ UInt8($0) })

    return String(bytes: bytes, encoding: .utf8) ?? model
  }
}
```