import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

@Slide
struct PR: View, WebPageProviding {
  let converter = MarkdownToSlideConverter()
  @Environment(\.slideTheme) var slideTheme

  let webPage = WebPage()

  var webPages: [WebPage] { [webPage] }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("PR")
          .font(slideTheme.headingH1Font)

        Text("Kanagawa.swift #3 @小田原")
          .font(slideTheme.headingH2Font)

        WebView(webPage)
          .task {
            webPage.load(
              URLRequest(url: URL(string: "https://japan-region-swift.connpass.com/event/389036/")!)
            )
          }
      }
    }
    .padding(slideTheme.contentPadding)
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview {
  SlidePreview {
    PR()
  }
}
