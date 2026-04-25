import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Concept: View {
  @Environment(\.slideTheme) var slideTheme

  enum SlidePhase: Int, PhasedState {
    case initial
    case block
    case inline
  }

  @Phase var phase: SlidePhase

  private let leftMarkdown: String = """
    # Title

    ## Sub title

    - List item 1
    - List item 2

    This is a paragraph, and **this is bold text**.
    This sentence is in the same paragraph.
    """

  var script: String {
    switch phase {
    case .initial:
      return """
        先ほどの画面と似たような感じですが、ここでは実装の方針をお話しします。
        """
    case .block:
      return """
        Block の要素の場合は VStack で縦に積んでいく感じ
        """
    case .inline:
      return """
        Inline の要素の場合は Text を結合する感じで実装をします。
        """
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 32) {
      Text("Concept")
        .font(slideTheme.headingH1Font)
        .frame(maxWidth: .infinity, alignment: .leading)

      GeometryReader { proxy in
        HStack(alignment: .top) {
          Text(leftMarkdown)
            .font(slideTheme.bodyFont)
            .frame(width: proxy.size.width / 2)

          let show = phase == .block || phase == .inline
          VStack(alignment: .leading, spacing: 32) {
            Text("Title")
              .font(slideTheme.headingH1Font)
              .opacity(show ? 1 : 0)
              .offset(y: show ? 0 : 20)
              .animation(.easeInOut, value: phase)

            Text("Sub title")
              .font(slideTheme.headingH2Font)
              .opacity(show ? 1 : 0)
              .offset(y: show ? 0 : 20)
              .animation(.easeInOut.delay(0.5), value: phase)

            Text("• List item 1")
              .font(slideTheme.bodyFont)
              .opacity(show ? 1 : 0)
              .offset(y: show ? 0 : 20)
              .animation(.easeInOut.delay(1.0), value: phase)

            Text("• List item 2")
              .font(slideTheme.bodyFont)
              .opacity(show ? 1 : 0)
              .offset(y: show ? 0 : 20)
              .animation(.easeInOut.delay(1.5), value: phase)

            let showInline = phase == .inline
            HStack(alignment: .top, spacing: 8) {
              Text("This is a paragraph, and ")
                .font(slideTheme.bodyFont)
                .opacity(showInline ? 1 : 0)
                .offset(x: showInline ? 0 : 20)
                .animation(.easeInOut, value: phase)

              Text("**this is bold text**")
                .font(slideTheme.bodyFont)
                .opacity(showInline ? 1 : 0)
                .offset(x: showInline ? 0 : 20)
                .animation(.easeInOut.delay(0.5), value: phase)

              Text(".")
                .font(slideTheme.bodyFont)
                .opacity(showInline ? 1 : 0)
                .offset(x: showInline ? 0 : 20)
                .animation(.easeInOut.delay(1.0), value: phase)
            }

            HStack(alignment: .top, spacing: 8) {
              Text("This sentence is in the same paragraph.")
                .font(slideTheme.bodyFont)
                .opacity(showInline ? 1 : 0)
                .offset(x: showInline ? 0 : 20)
                .animation(.easeInOut.delay(1.5), value: phase)
            }
          }
          .frame(width: proxy.size.width / 2)
        }
      }

      switch phase {
      case .block:
        Text("VStack")
          .font(slideTheme.headingH2Font)
      case .inline:
        Text("Text 結合")
          .font(slideTheme.headingH2Font)
      case .initial:
        EmptyView()
      }
    }
    .padding(slideTheme.contentPadding)
    .background(slideTheme.backgroundColor)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview("Initial") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<Concept.SlidePhase>(.initial)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        Concept()
      }
    )
  }
}

#Preview("Block") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<Concept.SlidePhase>(.block)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        Concept()
      }
    )
  }
}

#Preview("Inline") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<Concept.SlidePhase>(.inline)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        Concept()
      }
    )
  }
}
