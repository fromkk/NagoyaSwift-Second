import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct AboutStructure: View {
  @Environment(\.slideTheme) var slideTheme

  enum SlidePhase: Int, PhasedState {
    case initial
    case document
    case block
    case inline
  }

  @Phase
  var phase: SlidePhase

  var script: String = """
    swift-markdown のデータ構造についてです。
    パースされた Markdown は Document を頂点とするツリー構造になっています。
    Document の直下には見出しやリストなどの Block 要素が並び、Block の中にはテキストや太字などの Inline 要素が含まれます。
    この3層の構造を意識することが、SwiftUI View への変換を実装する上で重要になります。
    """

  let sampleMarkdown = """
    # Title

    ## Sub title

    - List item 1
    - List item 2

    This is a paragraph, and **this is bold text**.
    This sentence is in the same paragraph.
    """

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        Text("About Structure")
          .font(slideTheme.headingH1Font)

        ZStack(alignment: .topLeading) {
          Text(sampleMarkdown)
            .font(slideTheme.bodyFont)
            .padding(32)

          if phase != .initial {
            RoundedRectangle(cornerRadius: 32)
              .stroke(Color.pink, style: .init(lineWidth: 8))
              .frame(maxWidth: borderWidth, maxHeight: borderHeight)
              .offset(borderOffset)
              .animation(.easeInOut, value: phase)
          }
        }

        switch phase {
        case .document:
          Text("Document")
            .font(slideTheme.headingH2Font)
        case .block:
          Text("Block")
            .font(slideTheme.headingH2Font)
        case .inline:
          Text("Inline")
            .font(slideTheme.headingH2Font)
        case .initial:
          EmptyView()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(slideTheme.contentPadding)
    }
    .background(slideTheme.backgroundColor)
  }

  var borderWidth: CGFloat {
    switch phase {
    case .document, .block, .initial:
      return .infinity
    case .inline:
      return 420
    }
  }
  var borderHeight: CGFloat {
    switch phase {
    case .document, .initial:
      return .infinity
    case .block, .inline:
      return 90
    }
  }

  var borderOffset: CGSize {
    switch phase {
    case .initial, .document:
      return .zero
    case .block:
      return .init(width: 0, height: 20)
    case .inline:
      return .init(width: 520, height: 420)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview("initial") {
  SlidePreview {
    AboutStructure()
  }
}

#Preview("document phase") {
  let container = ObservableObjectContainer()
  _ = container.resolve { PhasedStateStore<AboutStructure.SlidePhase>(.document) }
  return SlideRouterView(slideIndexController: SlideIndexController(container: container) {
    AboutStructure()
  })
}

#Preview("block phase") {
  let container = ObservableObjectContainer()
  _ = container.resolve { PhasedStateStore<AboutStructure.SlidePhase>(.block) }
  return SlideRouterView(slideIndexController: SlideIndexController(container: container) {
    AboutStructure()
  })
}

#Preview("inline phase") {
  let container = ObservableObjectContainer()
  _ = container.resolve { PhasedStateStore<AboutStructure.SlidePhase>(.inline) }
  return SlideRouterView(slideIndexController: SlideIndexController(container: container) {
    AboutStructure()
  })
}
