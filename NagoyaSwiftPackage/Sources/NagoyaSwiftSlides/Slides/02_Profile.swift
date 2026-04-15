import MarkdownToView
import SlideKit
import SwiftUI

@Slide
struct ProfileSlide: View {
  var body: some View {
    let parser = MarkdownToSlide()
    parser.parsePage(
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

  var transition: any Transition {
    .push(from: .trailing)
  }
}

#Preview {
  SlidePreview {
    ProfileSlide()
  }
}
