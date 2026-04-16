import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct MakeUI: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """

    """

  var body: some View {
    SlideWrapper {
      VStack(alignment: .leading, spacing: 32) {
        
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(slideTheme.contentPadding)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    MakeUI()
  }
}
