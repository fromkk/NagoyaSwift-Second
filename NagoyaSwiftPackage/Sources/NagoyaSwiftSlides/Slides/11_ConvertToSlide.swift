import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

@Slide
struct ConvertToSlide: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """
    スライドへの変換についてです。
    Markdown から View を作る方法だと API 的に足りないものがあったので、PR を作成してコントリビュートすることで解決しました。
    """

  var body: some View {
    HStack {
      SlideWrapper {
        converter.convertPage("""
          # Convert to slide

          - Markdown から View を作る方法だと **API 的に足りないもの**があった
          - PR を作成してコントリビュートすることで解決
          - [https://github.com/mtj0928/SlideKit/pull/47](https://github.com/mtj0928/SlideKit/pull/47)
          - https://x.com/fromkk/status/2008524925607563362
          """)
      }
      WebView(url: URL(string: "https://github.com/mtj0928/SlideKit/pull/47/changes"))
    }
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    ConvertToSlide()
  }
}
