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
    }
  }

  enum SlidePhase: Int, PhasedState {
    case initial  // block
    case inline
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
      }

    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    AboutParse()
  }
}
