import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Demo: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var body: some View {
    converter.convertPage("""
      # Demo
      """)
    .background(slideTheme.backgroundColor)
  }
}

#Preview {
  SlidePreview {
    Demo()
  }
}
