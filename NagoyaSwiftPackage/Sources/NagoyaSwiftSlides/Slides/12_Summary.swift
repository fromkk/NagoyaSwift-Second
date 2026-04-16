import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Summary: View {
  let converter = MarkdownToSlideConverter()

  var script: String = """
    まとめです。
    swift-markdownはCommonMark準拠の型安全なMarkdownパーサーです。
    MarkupVisitorを実装することでSwiftUIのViewに変換できます。
    実際にTypeアプリのプレビュー機能で活用しています。
    ご清聴ありがとうございました。
    """

  var body: some View {
    SlideWrapper {
      converter.convertPage("""
        # Summary

        - **swift-markdown** は CommonMark 準拠・型安全な Apple 製パーサー
        - `Document(parsing:)` で AST を取得
        - **MarkupVisitor** で各ノードを SwiftUI View に変換
        - ListItem・SoftBreak・インラインネストに注意
        - MarkdownエディターのプレビューにSwiftで挑戦してみよう
        """)
    }
  }

  var transition: AnyTransition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    Summary()
  }
}
