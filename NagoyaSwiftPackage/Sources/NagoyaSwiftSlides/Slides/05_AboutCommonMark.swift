import MarkdownToSlide
import SlideKit
import SwiftUI
import WebKit

@Slide
struct AboutCommonMark: View, WebPageProviding {
  enum SlidePhase: Int, PhasedState {
    case initial
    case commonmark
  }

  @Phase
  var phase: SlidePhase

  @Environment(\.slideTheme) var slideTheme

  let converter = MarkdownToSlideConverter()
  let webPage = WebPage()

  var webPages: [WebPage] { [webPage] }

  var script: String {
    switch phase {
    case .initial:
      return """
        Markdownが普及するにつれ、様々な方言が生まれました。
        GitHub Flavored Markdown、MultiMarkdown、kramdownなど、それぞれが独自の拡張を持っています。
        """
    case .commonmark:
      return """
        そこでJohn MacFarlaneらが2014年にCommonMarkを策定しました。
        CommonMarkはMarkdownの曖昧さをなくし、厳密な仕様を定義したものです。
        """
    }
  }

  var body: some View {

    VStack(alignment: .leading, spacing: 32) {
      if phase == .initial {
        SlideWrapper {
          converter.convertPage(
            """
            ## Markdownの方言問題

            - **GitHub Flavored Markdown** — テーブル・タスクリストなど独自拡張
            - **MultiMarkdown** — 脚注・数式など
            - **kramdown** — Rubyエコシステムで普及
            - 実装によって挙動が異なる → **相互運用性の問題**
            """
          )
          .transition(.opacity)
        }
      } else if phase == .commonmark {
        GeometryReader { proxy in
          HStack {
            converter.convertPage(
              """
              ## CommonMark(2014年〜)

              - John MacFarlane らが策定した **厳密なMarkdown仕様**
              - GitHubやStack Overflow、Redditなど、主要プラットフォームの開発者たちが主導
              - 標準的で相互運用可能な「構文仕様」と、実装を検証するための「包括的なテスト」を提供
              - [https://commonmark.org/](https://commonmark.org/)
              """
            )
            .transition(.opacity)
            .frame(width: proxy.size.width * 0.6)
            WebView(webPage)
              .task { webPage.load(URLRequest(url: URL(string: "https://commonmark.org/")!)) }
          }
        }
      }
    }
    .padding(slideTheme.contentPadding)
    .background(slideTheme.backgroundColor)
    .animation(.easeInOut, value: phase)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview("initial phase") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<AboutCommonMark.SlidePhase>(.initial)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        AboutCommonMark()
      }
    )
  }
}

#Preview("commonmark phase") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<AboutCommonMark.SlidePhase>(.commonmark)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        AboutCommonMark()
      }
    )
  }
}
