import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct ConvertToSlide: View {
  let converter = MarkdownToSlideConverter()

  var script: String = """
    スライドへの変換についてです。
    Markdown から View を作る方法だと API 的に足りないものがあったので、PR を作成してコントリビュートすることで解決しました。
    """

  var body: some View {
    SlideWrapper {
      converter.convertPage("""
        # Convert to slide

        - Markdown から View を作る方法だと **API 的に足りないもの**があった
        - PR を作成してコントリビュートすることで解決
        - https://github.com/mtj0928/SlideKit/pull/47
        - https://x.com/fromkk/status/2008524925607563362?s=20
        """)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    ConvertToSlide()
  }
}
