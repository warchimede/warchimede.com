import Plot

public extension Node where Context: HTMLContext {
  static func path(d: String, nodes: Node<HTML.BodyContext>...) -> Node {
    return .element(named: "path", nodes: [
      .attribute(named: "d", value: d),
      .forEach(nodes) { $0 }
    ])
  }

  static func svg(viewBox: String, nodes: Node<HTML.BodyContext>...) -> Node<HTML.AnchorContext> {
    return .element(named: "svg", nodes: [
      .attribute(named: "xmlns", value: "http://www.w3.org/2000/svg"),
      .attribute(named: "viewBox", value: viewBox),
      .forEach(nodes) { $0 }
    ])
  }
}