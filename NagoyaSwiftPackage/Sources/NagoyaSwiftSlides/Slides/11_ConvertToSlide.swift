import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct ConvertToSlide: View {
  @Environment(\.slideTheme) var slideTheme

  var body: some View {
    SlideWrapper {
      Text("Convert to slide")
        .font(slideTheme.headingH1Font)
    }
  }
}

#Preview {
  SlidePreview {
    ConvertToSlide()
  }
}
