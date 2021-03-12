---
date: 2020-12-17 17:30
description:
tags: ios, swift
---
# Gist: Swift `String` extension allowing conversion to slug format

```swift
import Foundation

extension String {
  private static let slugSeparator = "_"
  private static let slugSafeCharacters = "0123456789abcdefghijklmnopqrstuvwxyz"

  public func convertedToSlug() -> String {
    return self
      .applyingTransform(StringTransform("Any-Latin; Latin-ASCII"), reverse: false)? // æ -> ae
      .applyingTransform(.stripDiacritics, reverse: false)? // é -> e
      .lowercased() // A -> a
      .split(whereSeparator: { !String.slugSafeCharacters.contains($0) }) // "🖤a:/a.,a;$-a" -> ["a", "a", "a", "a"]
      .joined(separator: String.slugSeparator) // ["a", "a", "a", "a"] -> "a_a_a_a"
      ?? ""
  }
}
```