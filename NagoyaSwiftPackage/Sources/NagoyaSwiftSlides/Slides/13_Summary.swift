import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct Summary: View {
  let converter = MarkdownToSlideConverter()

  var script: String = """
    まとめです。

    以上です。ご清聴ありがとうございました。
    """

  var body: some View {
    SlideWrapper {
      converter.convertPage("""
        # Summary

        
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
