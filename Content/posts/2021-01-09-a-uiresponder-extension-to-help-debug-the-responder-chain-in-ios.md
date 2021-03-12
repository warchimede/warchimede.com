---
date: 2021-01-29 17:30
description: For when the view hierarchy is painful
tags: ios, swift
---
# A `UIResponder` extension to help debug the responder chain in iOS

I recently had to debug a complex view hierarchy and find out why touch events were not handled by some `UIViewController` in the responder chain.

Well, this small `UIResponder` extension turned out to be of great help :

```swift
public extension UIResponder {
  func printResponderChain() {
    print(self)
    next?.printResponderChain()
  }
}
```

For example, by calling `printResponderChain()` on a `UIView`, it recursively prints the whole related chain, so you can figure out where things get weird.