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

  var script: String = """
    Turning Markdown into Slides with swift-markdown and SlideKit ということで、swift-markdown と SlideKit を使って Markdown をスライドにする方法をお話しします。 
    """
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
