import Foundation
import Plot
import Publish

extension Theme where Site == WarchimedeCom {
  static var warchimede: Self {
    Theme(
      htmlFactory: WarchimedeHTMLFactory(),
      resourcePaths: ["Resources/WarchimedeTheme/styles.css"]
    )
  }
}

private struct WarchimedeHTMLFactory<Site: Website>: HTMLFactory {
  func makeIndexHTML(for index: Index,
                      context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: index, on: context.site),
      .body(
        .header(for: context, selectedSection: nil),
        .wrapper(
          .h1(.text("Hello there, my name is William 👋🏽")),
          .p(
            .class("description"),
            .text(context.site.description)
          ),
          .h2("Latest content"),
          .itemList(
            for: context.allItems(
              sortedBy: \.date,
              order: .descending
            ),
            on: context.site
          )
        ),
        .footer(for: context.site)
      )
    )
  }

  func makeSectionHTML(for section: Section<Site>,
                        context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: section, on: context.site),
      .body(
        .header(for: context, selectedSection: section.id),
        .wrapper(
          .h1(.text(section.title)),
          .itemList(for: section.items, on: context.site)
        ),
        .footer(for: context.site)
      )
    )
  }

  func makeItemHTML(for item: Item<Site>,
                    context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: item, on: context.site),
      .body(
        .class("item-page"),
        .header(for: context, selectedSection: item.sectionID),
        .wrapper(
          .article(
            .p(.text(item.date.formatted)),
            .div(
              .class("content"),
              .contentBody(item.body)
            ),
            .span("Tagged with: "),
            .tagList(for: item, on: context.site)
          )
        ),
        .footer(for: context.site)
      )
    )
  }

  func makePageHTML(for page: Page,
                    context: PublishingContext<Site>) throws -> HTML {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body(
        .header(for: context, selectedSection: nil),
        .wrapper(.contentBody(page.body)),
        .footer(for: context.site)
      )
    )
  }

  func makeTagListHTML(for page: TagListPage,
                        context: PublishingContext<Site>) throws -> HTML? {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body(
        .header(for: context, selectedSection: nil),
        .wrapper(
          .h1("Browse all tags"),
          .ul(
            .class("all-tags"),
            .forEach(page.tags.sorted()) { tag in
              .li(
                .class("tag"),
                .a(
                  .href(context.site.path(for: tag)),
                  .text(tag.string)
                )
              )
            }
          )
        ),
        .footer(for: context.site)
      )
    )
  }

  func makeTagDetailsHTML(for page: TagDetailsPage,
                          context: PublishingContext<Site>) throws -> HTML? {
    HTML(
      .lang(context.site.language),
      .head(for: page, on: context.site),
      .body(
        .header(for: context, selectedSection: nil),
        .wrapper(
          .h1(
            "Tagged with ",
            .span(.class("tag"), .text(page.tag.string))
          ),
          .a(
            .class("browse-all"),
            .text("Browse all tags"),
            .href(context.site.tagListPath)
          ),
          .itemList(
            for: context.items(
              taggedWith: page.tag,
              sortedBy: \.date,
              order: .descending
            ),
            on: context.site
          )
        ),
        .footer(for: context.site)
      )
    )
  }
}

private extension Node where Context == HTML.BodyContext {
  static func wrapper(_ nodes: Node...) -> Node {
    .div(.class("wrapper"), .group(nodes))
  }

  static func header<T: Website>(
    for context: PublishingContext<T>,
    selectedSection: T.SectionID?
  ) -> Node {
    let sectionIDs = T.SectionID.allCases

    return .header(
      .wrapper(
        .a(.class("site-name"), .href("/"), .text(context.site.name)),
        .if(sectionIDs.count > 1,
          .nav(
            .ul(.forEach(sectionIDs) { section in
              .li(.a(
                .class(section == selectedSection ? "selected" : ""),
                .href(context.sections[section].path),
                .text(context.sections[section].title)
              ))
            })
          )
        )
      )
    )
  }

  static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
    return .ul(
      .class("item-list"),
      .forEach(items) { item in
        .li(itemListNode(for: item, on: site))
      }
    )
  }

  static func itemListNode<T: Website>(for item: Item<T>, on site: T) -> Node {
    return .article(
      .p(.text(item.date.formatted)),
      .h1(.a(
        .href(item.path),
        .text(item.title)
      )),
      .tagList(for: item, on: site),
      .p(.text(item.description))
    )
  }

  static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
    return .ul(.class("tag-list"), .forEach(item.tags) { tag in
      .li(.a(
        .href(site.path(for: tag)),
        .text(tag.string)
      ))
    })
  }

  static func footer<T: Website>(for site: T) -> Node {
    return .footer(
      .socialIcons(for: site),
      .p(
        .text("Generated using "),
        .a(
          .text("Publish"),
          .href("https://github.com/johnsundell/publish")
        )
      )
    )
  }

  static func socialIcon(href: String, ariaLabel: String, nodes: Node<HTML.AnchorContext>...) -> Node {
    return .a(
      .href(href),
      .ariaLabel(ariaLabel),
      .target(.blank),
      .rel(.noopener),
      .class("social-icon"),
      .forEach(nodes) { $0 }
    )
  }

  static func socialIcons<T: Website>(for site: T) -> Node {
    return .div(
      .group(
        .socialIcon(href: "https://twitter.com/warchimede", ariaLabel: "Find me on Twitter", nodes:
          .svg(viewBox: "0 0 512 512", nodes:
            .path(d: "M459.37 151.716c.325 4.548.325 9.097.325 13.645 0 138.72-105.583 298.558-298.558 298.558-59.452 0-114.68-17.219-161.137-47.106 8.447.974 16.568 1.299 25.34 1.299 49.055 0 94.213-16.568 130.274-44.832-46.132-.975-84.792-31.188-98.112-72.772 6.498.974 12.995 1.624 19.818 1.624 9.421 0 18.843-1.3 27.614-3.573-48.081-9.747-84.143-51.98-84.143-102.985v-1.299c13.969 7.797 30.214 12.67 47.431 13.319-28.264-18.843-46.781-51.005-46.781-87.391 0-19.492 5.197-37.36 14.294-52.954 51.655 63.675 129.3 105.258 216.365 109.807-1.624-7.797-2.599-15.918-2.599-24.04 0-57.828 46.782-104.934 104.934-104.934 30.213 0 57.502 12.67 76.67 33.137 23.715-4.548 46.456-13.32 66.599-25.34-7.798 24.366-24.366 44.833-46.132 57.827 21.117-2.273 41.584-8.122 60.426-16.243-14.292 20.791-32.161 39.308-52.628 54.253z")
          )
        ),
        .socialIcon(href: "https://github.com/warchimede", ariaLabel: "Find me on Github", nodes:
          .svg(viewBox: "0 0 24 24", nodes:
            .path(d: "M12 2A10 10 0 0 0 2 12c0 4.42 2.87 8.17 6.84 9.5.5.08.66-.23.66-.5v-1.69c-2.77.6-3.36-1.34-3.36-1.34-.46-1.16-1.11-1.47-1.11-1.47-.91-.62.07-.6.07-.6 1 .07 1.53 1.03 1.53 1.03.87 1.52 2.34 1.07 2.91.83.09-.65.35-1.09.63-1.34-2.22-.25-4.55-1.11-4.55-4.92 0-1.11.38-2 1.03-2.71-.1-.25-.45-1.29.1-2.64 0 0 .84-.27 2.75 1.02.79-.22 1.65-.33 2.5-.33.85 0 1.71.11 2.5.33 1.91-1.29 2.75-1.02 2.75-1.02.55 1.35.2 2.39.1 2.64.65.71 1.03 1.6 1.03 2.71 0 3.82-2.34 4.66-4.57 4.91.36.31.69.92.69 1.85V21c0 .27.16.59.67.5C19.14 20.16 22 16.42 22 12A10 10 0 0 0 12 2z")
          )
        ),
        .socialIcon(href: "https://www.linkedin.com/in/william-archimede-62651459/", ariaLabel: "Find me on LinkedIn", nodes:
          .svg(viewBox: "0 0 24 24", nodes:
            .path(d: "M16 8a6 6 0 016 6v7h-4v-7a2 2 0 00-2-2 2 2 0 00-2 2v7h-4v-7a6 6 0 016-6z"),
            .rect(x: 2, y: 9, width: 4, height: 12),
            .circle(cx: 4, cy: 4, r: 2)
          )
        ),
        .socialIcon(href: "/feed.rss", ariaLabel: "RSS feed", nodes:
          .svg(viewBox: "0 0 448 512", nodes:
            .path(d: "M80 368c17.645 0 32 14.355 32 32s-14.355 32-32 32-32-14.355-32-32 14.355-32 32-32m0-48c-44.183 0-80 35.817-80 80s35.817 80 80 80 80-35.817 80-80-35.817-80-80-80zm367.996 147.615c-6.449-237.834-198.057-429.163-435.61-435.61C5.609 31.821 0 37.229 0 44.007v24.02c0 6.482 5.147 11.808 11.626 11.992 211.976 6.04 382.316 176.735 388.354 388.354.185 6.479 5.51 11.626 11.992 11.626h24.02c6.78.001 12.187-5.608 12.004-12.384zm-136.239-.05C305.401 305.01 174.966 174.599 12.435 168.243 5.643 167.977 0 173.444 0 180.242v24.024c0 6.431 5.072 11.705 11.497 11.98 136.768 5.847 246.411 115.511 252.258 252.258.275 6.425 5.549 11.497 11.98 11.497h24.024c6.797-.001 12.264-5.644 11.998-12.436z")
          )
        )
      )
    )
  }
}
