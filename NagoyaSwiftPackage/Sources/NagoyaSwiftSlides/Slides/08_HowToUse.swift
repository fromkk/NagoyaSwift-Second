import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct HowToUse: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """
    swift-markdownの使い方を見ていきましょう。
    まずSPMでパッケージを追加します。
    パースはシンプルで、Document(parsing:)にMarkdown文字列を渡すだけです。
    返ってくるDocumentがASTのルートノードです。
    """

  var body: some View {
    SlideWrapper {
      VStack(alignment: .leading, spacing: 32) {
        Text("How to Use swift-markdown")
          .font(slideTheme.headingH1Font)

        converter.convertPage(
          """
          ## 1. SPM で追加

          ```swift
          .package(
            url: "https://github.com/swiftlang/swift-markdown.git",
            from: "0.7.0"
          )
          ```

          ## 2. パース

          ```swift
          import Markdown

          let source = "# Hello, **world**!"
          let document = Document(parsing: source)
          """)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(slideTheme.contentPadding)
    }
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    HowToUse()
  }
}
