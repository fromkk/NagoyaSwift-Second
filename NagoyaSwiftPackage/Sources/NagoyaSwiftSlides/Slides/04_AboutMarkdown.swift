import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

@Slide
struct AboutMarkdown: View, WebPageProviding {
  @Environment(\.slideTheme) var slideTheme

  let markdown = """
    # About Markdown

    ## Markdown.pl

    - John Gruber と Aaron Swartz が共同で2004年に作成した **独自テキストをHTMLに変換するツール** から始まった
    - 元々はウェブライター向けのテキスト・HTML変換ツール
    - 可能な限り読みやすくするために設計された
    - [https://daringfireball.net/projects/markdown/](https://daringfireball.net/projects/markdown/)
    """

  let converter = MarkdownToSlideConverter()
  let webPage = WebPage()

  var webPages: [WebPage] { [webPage] }

  var script: String = """
    Markdown についてです。
    Markdown は、John Gruber と Aaron Swartz が共同で2004年に作成した、独自テキストをHTMLに変換するツールから始まりました。
    元々はウェブライター向けのテキスト・HTML変換ツールで、可能な限り読みやすくなるように設計されています。
    """

  var body: some View {
    HStack {
      converter.convertPage(markdown)
        .background(slideTheme.backgroundColor)
      WebView(webPage)
        .task {
          webPage.load(
            URLRequest(url: URL(string: "https://daringfireball.net/projects/markdown/")!))
        }
    }
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    AboutMarkdown()
  }
}
