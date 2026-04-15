import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct AboutType: View {
  @Environment(\.slideTheme) var slideTheme

  let markdown: String = """
    # About # Type

    - 2017年にリリースしたMarkdownエディター
    - Swift・UIKit製（最近のアプデはSwiftUIも）
    - 基本無料
    - https://apps.apple.com/jp/app/type/id1214613873
    """

  var script: String = """
    前提としてTypeについてお話しします。
    Typeは2017年にリリースしたシンプルなMarkdownエディターです。
    SwiftとUIKit製のアプリです。最近のアプデでSwiftUIを利用する箇所も出てきています。
    基本無料で利用可能です。
    """

  private let converter = MarkdownToSlideConverter()

  var body: some View {
    SlideWrapper {
      HStack(alignment: .top) {
        VStack(alignment: .leading) {
          converter.convertPage(markdown)

          Image(.typeQr)
            .resizable()
            .frame(width: 400, height: 400)
        }

        VStack {
          Image(.typeSs)
        }
      }
      .padding(slideTheme.contentPadding)
    }
  }

  var transition: AnyTransition = .push(from: .trailing)
}

#Preview {
  SlidePreview {
    AboutType()
  }
}
