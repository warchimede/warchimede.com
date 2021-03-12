---
date: 2020-03-27 17:30
description:
tags: ios, swift
---
# Gist: HTML string interpretation in Swift, using `NSAttributedString`, with custom `UIFont` support

```swift
import Foundation
import UIKit

extension String {
  func convertHtml(using font: UIFont?) -> NSAttributedString {
    // Template html string to apply custom otf font using a <div/> tag
    var str = self
    if let font = font {
      str = "<div style=\"font-family: '\(font.familyName)'\">\(self)</div>"
    }

    guard let data = str.data(using: .unicode) else { return NSAttributedString() }
    do {
      return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
}
```