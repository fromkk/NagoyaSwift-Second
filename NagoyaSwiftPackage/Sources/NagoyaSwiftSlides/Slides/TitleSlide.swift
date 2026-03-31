import SlideKit
import SwiftUI

@Slide
struct TitleSlide: View {
  var shouldHideIndex: Bool { true }

  var body: some View {
    VStack(spacing: 24) {
      Text("Nagoya.swift #2")
        .font(.system(size: 120, weight: .bold))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  SlidePreview {
    TitleSlide()
  }
}
