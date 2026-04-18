import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct MakeUI: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String = """

    """

  enum SlidePhase: Int, PhasedState {
    case initial
  }

  @Phase var phase: SlidePhase

  var body: some View {
    SlideWrapper {
      if phase == .initial {
        converter.convertPage("""
          - `document.children: MarkupChildren`
          """)
      }
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview("initial") {
  SlidePreview {
    MakeUI()
  }
}
