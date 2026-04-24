import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct PR: View {
  let converter = MarkdownToSlideConverter()
  @Environment(\.slideTheme) var slideTheme

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("PR")
          .font(slideTheme.headingH1Font)

        Text("Kanagawa.swift #3 @小田原")
          .font(slideTheme.headingH2Font)

        WebContentView(
          url: URL(string: "https://japan-region-swift.connpass.com/event/389036/")!
        )
      }
    }
    .padding(slideTheme.contentPadding)
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())

  var script: String = """
    最後に宣伝です。
    といってもすでに埋まってるんですが、ハロウィーンの日に Kanagawa.swift #3 を小田原で開催します。
    もし興味あるよーという方がいましたら僕かすぎーさんまでお声がけください。
    以上です。ご清聴ありがとうございました。
    """
}

#Preview {
  SlidePreview {
    PR()
  }
}
