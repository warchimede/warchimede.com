---
date: 2025-04-24 17:50
description: encoder.outputFormatting = .sortedKeys
tags: ios, swift, codable
---
# How to sort JSON keys in lexicographic order when encoding data

In order to achieve this goal - which can help with quickly reading through large JSONs or making tests easier - you can use `.sortedKeys` as the value for the `outputFormatting` property of `JSONEncoder`.

For convenience, you can create a small extension :

```swift
extension JSONEncoder {
  static func withSortedKeys() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    return encoder
  }
}
```

And for an even easier reading experience, you can combine it with `.prettyPrinted`:

```swift
encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
```