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

  var transition: AnyTransition = .push(from: .trailing)
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
