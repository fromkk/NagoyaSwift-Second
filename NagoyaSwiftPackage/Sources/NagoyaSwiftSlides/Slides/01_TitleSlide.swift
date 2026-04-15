import MarkdownToView
import SlideKit
import SwiftUI

@Slide
struct TitleSlide: View {
  var shouldHideIndex: Bool { true }

  var body: some View {
    SlideWrapper {
      let parser = MarkdownToSlide()
      parser.parsePage(
        """
        # Turning Markdown into Slides with swift-markdown and SlideKit
        """
      )
    }
  }
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
