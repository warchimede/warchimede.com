import Foundation
import Publish
import Plot
import SplashPublishPlugin

// This type acts as the configuration for your website.
struct WarchimedeCom: Website {
  enum SectionID: String, WebsiteSectionID {
    // Add the sections that you want your website to contain here:
    case posts
  }

  struct ItemMetadata: WebsiteItemMetadata {
    // Add any site-specific metadata that you want to use here.
  }

  // Update these properties to configure your website:
  var url = URL(string: "https://warchimede.com")!
  var name = "warchimede.com"
  var description = "A description of warchimede.com"
  var language: Language { .english }
  var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
// try WarchimedeCom().publish(withTheme: .foundation)
try WarchimedeCom().publish(using: [
  .installPlugin(.splash(withClassPrefix: "")),
  .addMarkdownFiles(),
  .copyResources(),
  .generateHTML(withTheme: .warchimede),
  .generateRSSFeed(including: [.posts]),
  .generateSiteMap()
])