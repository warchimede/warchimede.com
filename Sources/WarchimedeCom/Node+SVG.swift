import Plot

public extension Node where Context: HTMLContext {
  static func path(d: String, nodes: Node<HTML.BodyContext>...) -> Node {
    return .element(named: "path", nodes: [
      .attribute(named: "d", value: d),
      .forEach(nodes) { $0 }
    ])
  }

  static func rect(x: UInt, y: UInt, width: UInt, height: UInt, nodes: Node<HTML.BodyContext>...) -> Node {
    return .element(named: "rect", nodes: [
      .attribute(named: "x", value: "\(x)"),
      .attribute(named: "y", value: "\(y)"),
      .attribute(named: "width", value: "\(width)"),
      .attribute(named: "height", value: "\(height)"),
      .forEach(nodes) { $0 }
    ])
  }

  static func circle(cx: UInt, cy: UInt, r: UInt, nodes: Node<HTML.BodyContext>...) -> Node {
    return .element(named: "circle", nodes: [
      .attribute(named: "cx", value: "\(cx)"),
      .attribute(named: "cy", value: "\(cy)"),
      .attribute(named: "r", value: "\(r)"),
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