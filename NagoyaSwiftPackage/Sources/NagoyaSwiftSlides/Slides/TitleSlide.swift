import MarkdownToView
import SlideKit
import SwiftUI

@Slide
struct TitleSlide: View {
  var shouldHideIndex: Bool { true }

  var body: some View {
    let parser = MarkdownToSlide()
    parser.parsePage(
      """
      # Nagoya.swift
      """
    )
  }
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
