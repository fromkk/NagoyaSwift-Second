import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct AboutMarkdown: View {
  let markdown = """
    # About Markdown
    
    ## Markdown.pl
    
    - John Gruber と Aaron Swartz が共同で2004年に作成した **独自テキストをHTMLに変換するツール** から始まった
    - 元々はウェブライター向けのテキスト・HTML変換ツール
    - 可能な限り読みやすくするために設計された
    - https://daringfireball.net/projects/markdown/
    """

  let converter = MarkdownToSlideConverter()

  var script: String = """
    Markdown についてです。
    Markdown は、John Gruber と Aaron Swartz が共同で2004年に作成した、独自テキストをHTMLに変換するツールから始まりました。
    元々はウェブライター向けのテキスト・HTML変換ツールで、可能な限り読みやすくなるように設計されています。
    """

  var body: some View {
    SlideWrapper {
      converter.convertPage(markdown)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    AboutMarkdown()
  }
}
