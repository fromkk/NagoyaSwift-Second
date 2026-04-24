import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct MakeUI: View {
  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()

  var script: String {
    switch phase {
    case .initial:
      return """
        まず document に Markdown を渡します。
        これだけでパースが完了します。
        続いて、blockChildren から AnyView の配列を取得します。
        """
    case .block:
      return """
        BlockMarkup を受け取ったらハンドリングを行います。
        見出しだったらフォントを大きくするとかそういうことをやっていきます。
        """
    case .inline:
      return """
        InlineMarkup を受け取ったらこちらもハンドリングを行います。
        Strongだったらフォントを太字にするとかそういうことをやっていきます。
        """
    }
  }

  enum SlidePhase: Int, PhasedState {
    case initial
    case block
    case inline
  }

  @Phase var phase: SlidePhase

  var body: some View {
    SlideWrapper {
      VStack {
        Text("Concept")
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(slideTheme.headingH2Font)
          .padding(slideTheme.contentPadding)

        if phase == .initial {
          converter.convertPage(
            """
            ```
            let document = Document(parsing: markdown)
            let views: [AnyView] = document.blockChildren.map {
              blockHandler($0)
            }
            ```
            """
          )
        } else if phase == .block {
          converter.convertPage(
            """
            ```
            func blockHandler(_ block: any BlockMarkup) -> AnyView {
              switch block {
              case let heading as Heading:
                let text = heading.inlineChildren
                  .reduce(SwiftUI.Text("")) { SwiftUI.Text("\\($0)\\(inlineHandler($1))") }
                return AnyView(text.font(.largeTitle))
              ...
              }
            }
            ```
            """
          )
        } else if phase == .inline {
          converter.convertPage(
            """
            ```
            func inlineHandler(_ inline: any InlineMarkup) -> Text {
              switch inline {
              case let text as Markdown.Text:
                return SwiftUI.Text(text.string)
              case let strong as Strong:
                return strong.inlineChildren
                  .reduce(SwiftUI.Text("")) { SwiftUI.Text("\\($0)\\(inlineHandler($1))") }
                  .bold()
              ...
              }
            }
            ```
            """
          )
        }
      }

    }
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview("initial") {
  let container = ObservableObjectContainer()
  _ = container.resolve {
    PhasedStateStore<MakeUI.SlidePhase>(.initial)
  }
  return SlideRouterView(
    slideIndexController: SlideIndexController(container: container) {
      MakeUI()
    }
  )
}

#Preview("block") {
  let container = ObservableObjectContainer()
  _ = container.resolve {
    PhasedStateStore<MakeUI.SlidePhase>(.block)
  }
  return SlideRouterView(
    slideIndexController: SlideIndexController(container: container) {
      MakeUI()
    }
  )
}

#Preview("inline") {
  let container = ObservableObjectContainer()
  _ = container.resolve {
    PhasedStateStore<MakeUI.SlidePhase>(.inline)
  }
  return SlideRouterView(
    slideIndexController: SlideIndexController(container: container) {
      MakeUI()
    }
  )
}
