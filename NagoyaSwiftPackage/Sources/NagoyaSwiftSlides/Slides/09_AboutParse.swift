import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct AboutParse: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String {
    switch phase {
    case .initial:
      return """
        Block の一覧がこちらです。
        """
    case .inline:
      return """
        Inline の一覧がこちらです。
        """
    case .others:
      return """
        他にも BlockContainer, InlineContainer というものがいます。
        """
    }
  }

  enum SlidePhase: Int, PhasedState {
    case initial  // block
    case inline
    case others
  }

  @Phase
  var phase: SlidePhase

  var body: some View {
    SlideWrapper {
      switch phase {
      case .initial:
        converter.convertPage(
          """
          ## BlockMarkup の種類

          - BlockQuote
          - CodeBlock
          - CustomBlock
          - Heading
          - HTMLBlock
          - Paragraph
          - Table
          - ThematicBreak
          - BlockDirective
          - DoxygenAbstract
          - DoxygenDiscussion
          - DoxygenNote
          - DoxygenParameter
          - DoxygenReturns
          - ListItem
          - OrderedList
          - UnorderedList
          - Document
          """
        )
      case .inline:
        converter.convertPage(
          """
          ## InlineMarkup の種類

          - Image
          - InlineAttributes
          - Link
          - SymbolLink
          - CustomInline
          - Emphasis
          - InlineCode
          - InlineHTML
          - LineBreak
          - SoftBreak
          - Strikethrough
          - Strong
          - Text
          """
        )
      case .others:
        converter.convertPage(
          """
          ## その他
          
          - BlockContainer
          - InlineContainer
          """
        )
      }
    }
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview("block") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<AboutParse.SlidePhase>(.initial)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        AboutParse()
      }
    )
  }
}

#Preview("inline") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<AboutParse.SlidePhase>(.inline)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        AboutParse()
      }
    )
  }
}

#Preview("others") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<AboutParse.SlidePhase>(.others)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        AboutParse()
      }
    )
  }
}
