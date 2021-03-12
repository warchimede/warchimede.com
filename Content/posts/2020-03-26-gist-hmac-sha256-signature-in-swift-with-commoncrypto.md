---
date: 2020-03-26 17:30
description: hmac and cheese
tags: ios, swift
---
# Gist: HMAC SHA256 signature generation in Swift, using `CommonCrypto`

```swift
import CommonCrypto

// CommonCrypto HMAC SHA256
func mac(secretKey: String, message: String) -> String {
  let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
  let mac = UnsafeMutablePointer<CChar>.allocate(capacity: digestLength)

  let cSecretKey: [CChar]? = secretKey.cString(using: .utf8)
  let cSecretKeyLength = secretKey.lengthOfBytes(using: .utf8)

  let cMessage: [CChar]? = message.cString(using: .utf8)
  let cMessageLength = message.lengthOfBytes(using: .utf8)

  CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cSecretKey, cSecretKeyLength, cMessage, cMessageLength, mac)

  let macData = Data(bytes: mac, count: digestLength)

  return macData.base64EncodedString()
}
```