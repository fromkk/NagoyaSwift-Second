import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct ConvertToSlide: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """
    スライドの表示についてです。
    Markdown から View を作る方法だと 元々の SlideKit では API 的に足りないものがありました。
    具体的には SlideIndexController の 初期化が slideBuilder が前提になっており、事前に作成した slides: [any Slide] を渡すということができない形になっていました。
    そこで slides: [any Slide] をそのまま渡して受け入れられるような PR を作成してコントリビュートすることで解決しました。
    """

  var body: some View {
    HStack {
      SlideWrapper {
        converter.convertPage(
          """
          # Display to slides

          - Markdown から View を作る方法だと **API 的に足りないもの**があった
            - `SlideIndexController` の 初期化が `slideBuilder` が前提
          - PR を作成してコントリビュートすることで解決
          - [https://github.com/mtj0928/SlideKit/pull/47](https://github.com/mtj0928/SlideKit/pull/47)
          - https://x.com/fromkk/status/2008524925607563362
          """)
      }
      WebContentView(url: URL(string: "https://github.com/mtj0928/SlideKit/pull/47/changes")!)
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
