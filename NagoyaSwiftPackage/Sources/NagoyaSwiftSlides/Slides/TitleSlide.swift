import MarkdownToView
import SlideKit
import SwiftUI

@Slide
struct TitleSlide: View {
  var shouldHideIndex: Bool { true }

  var body: some View {
    MarkdownToView.convert(
      """
      # Nagoya.swift

      ## Swift Conference in Nagoya, Japan
      """
    )
  }
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
