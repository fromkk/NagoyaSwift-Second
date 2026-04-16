import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct ProfileSlide: View {
  var body: some View {
    SlideWrapper {
      let converter = MarkdownToSlideConverter()
      converter.convertPage(
        """
        # Profile
        ```
        struct Profile {
          let name = "Kazuya Ueoka"
          let job = "iOS Developer"
          let x = "@fromkk"
          let github = "fromkk"
          let note = "fromkk"
          let basedOn = "Saitama, Japan"
          let favorite = "Photography"
        }
        ```
        """)
    }
  }

  var transition: AnyTransition = .push(from: .trailing)

  var script: String = """
    植岡　和哉と申します。
    iOSアプリを作る仕事をしています。
    インターネットでは @fromkk というアカウントで活動しているのでよかったらフォローしてください。
    カメラで写真を撮るのが好きです。
    """
}

#Preview {
  SlidePreview {
    ProfileSlide()
  }
}
