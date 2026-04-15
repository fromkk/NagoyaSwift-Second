import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct TitleSlide: View {
  var shouldHideIndex: Bool { true }

  var body: some View {
    SlideWrapper {
      let converter = MarkdownToSlideConverter()
      converter.convertPage(
        """
        # Turning Markdown into Slides with swift-markdown and SlideKit
        """
      )
    }
  }

  var transition: AnyTransition = .push(from: .trailing)
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
