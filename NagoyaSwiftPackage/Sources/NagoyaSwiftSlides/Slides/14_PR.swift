import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

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

        WebView(url: URL(string: "https://japan-region-swift.connpass.com/event/389036/"))
      }
    }
    .padding(slideTheme.contentPadding)
  }

  var transition: AnyTransition = .opacity
}

#Preview {
  SlidePreview {
    PR()
  }
}
