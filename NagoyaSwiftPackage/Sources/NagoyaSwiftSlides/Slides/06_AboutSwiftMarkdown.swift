import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

@Slide
struct AboutSwiftMarkdown: View, WebPageProviding {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()
  let webPage = WebPage()

  var webPages: [WebPage] { [webPage] }

  var script: String = """
    swift-markdownはAppleが開発しているオープンソースのMarkdownパーサーです。
    swift-package-managerのドキュメント生成にも使われています。
    CommonMark仕様に準拠しており、Swiftネイティブで型安全なASTを提供します。
    さらにGitHub Flavored Markdownの拡張仕様にも対応しています。
    テーブルやタスクリスト、打ち消し線なども扱えます。
    """

  var body: some View {
    HStack {
      SlideWrapper {
        converter.convertPage(
          """
          # About swift-markdown

          - Apple が開発するオープンソースライブラリ
          - swift-package-manager のドキュメント生成にも採用
          - GitHub Flavored Markdown (GFM) 拡張に対応
          - Swiftネイティブ・型安全なAST
          - [https://github.com/swiftlang/swift-markdown](https://github.com/swiftlang/swift-markdown)
          """)
      }
      WebView(webPage)
        .task {
          webPage.load(URLRequest(url: URL(string: "https://github.com/swiftlang/swift-markdown")!))
        }
    }
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    AboutSwiftMarkdown()
  }
}
