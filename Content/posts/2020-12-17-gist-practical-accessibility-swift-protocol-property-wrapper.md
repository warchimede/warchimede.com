---
date: 2020-12-17 17:30
description: a11y is your ally
tags: ios, swift
---
# Gist: More practical Accessibility in Swift using a protocol and a property wrapper

## Example of usage
```swift
@Accessible(text: "Hello world", language: "en-US", traits: .button)
@IBOutlet var imageView: UIImageView!
```

## Implementation
```swift
import UIKit
import Foundation

protocol AccessibleViewProtocol {
  func setAccessibility(with text: String, language: String, traits: UIAccessibilityTraits?)
}

extension AccessibleViewProtocol where Self: UIView {
  func setAccessibility(with text: String, language: String, traits: UIAccessibilityTraits? = nil) {
    isAccessibilityElement = UIAccessibility.isVoiceOverRunning
    accessibilityLabel = text
    accessibilityLanguage = language

    if let traits = traits {
      accessibilityTraits = traits
    }
  }
}

extension UIView: AccessibleViewProtocol {}

@propertyWrapper
struct Accessible<Value: UIView> {
  let text: String
  var language: String = "fr-FR"
  var traits: UIAccessibilityTraits? = nil

  var wrappedValue: Value? {
    didSet {
      wrappedValue?.setAccessibility(with: text, language: language, traits: traits)
    }
  }
}
```