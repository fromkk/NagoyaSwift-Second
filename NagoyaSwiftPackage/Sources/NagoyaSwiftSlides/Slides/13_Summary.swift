import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Summary: View {
  let converter = MarkdownToSlideConverter()

  var script: String = """
    まとめです。
    # Type というアプリを紹介させていただきました。
    そして Markdown や CommonMark を紹介し、
    swift-markdown で Block や Inline をハンドリングして UI を作成して、
    SlideKit に PR を出して事前に生成した UI でもスライド対応できるようにしました。
    以上です。ご清聴ありがとうございました。
    """

  var body: some View {
    SlideWrapper {
      converter.convertPage("""
        # Summary

        - `# Type` というアプリの紹介
        - Markdown や CommonMark を紹介
        - swift-markdown で Block や Inline をハンドリングして UI を作成
        - SlideKit に PR を出して事前に生成した UI でもスライド対応
        """)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    Summary()
  }
}
