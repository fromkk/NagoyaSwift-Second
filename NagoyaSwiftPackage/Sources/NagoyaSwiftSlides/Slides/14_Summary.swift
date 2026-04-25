import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Summary: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """
    まとめです。
    # Type というアプリを紹介させていただきました。
    そして Markdown や CommonMark を紹介し、
    swift-markdown で Block や Inline をハンドリングして UI を作成して、
    SlideKit に PR を出して事前に生成した UI でもスライド対応できるようにしました。
    """

  var body: some View {
    SlideWrapper {
      HStack {
        converter.convertPage(
          """
          # Summary

          - `# Type` というアプリの紹介
          - Markdown や CommonMark を紹介
          - swift-markdown で Block や Inline をハンドリングして UI を作成
          - SlideKit に PR を出して事前に生成した UI でもスライド対応
          - 資料置き場: [https://github.com/fromkk/NagoyaSwift-Second](https://github.com/fromkk/NagoyaSwift-Second)
          """)

        Image(.nagoyaSwiftRepoQr)
          .resizable()
          .frame(width: 300, height: 300)
      }
      .padding(slideTheme.contentPadding)
    }
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    Summary()
  }
}
