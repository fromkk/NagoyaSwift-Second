import MarkdownToSlide
import SlideKit
import SwiftUI

@Slide
struct ProfileSlide: View {
  let converter = MarkdownToSlideConverter()
  @Environment(\.slideTheme) var slideTheme

  enum SlidePhase: Int, PhasedState {
    case initial
    case lastYear
    case apply
  }
  @Phase var phase: SlidePhase

  var body: some View {
    switch phase {
    case .initial:
      SlideWrapper {
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
          """
        )
      }
    case .lastYear, .apply:
      HStack {
        VStack(alignment: .leading) {
          converter.convertPage(
            """
            ## 昨年

            - Nagoya.swift #1 ではカメラマンとしてスタッフをしていました
            - 今年は？？？
            """ + (phase == .lastYear ? "" : "\n- 登壇者として申し込むことにしました")
          )
          .frame(maxWidth: .infinity, alignment: .leading)

          Image(.lastYear)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }

        WebContentView(
          url: URL(
            string:
              "https://japan-region-swift.connpass.com/event/376480/participation/#participants"
          )!
        )
      }
      .padding(slideTheme.contentPadding)
      .background(slideTheme.backgroundColor)
    }
  }

  var script: String {
    switch phase {
    case .initial:
      return """
        植岡　和哉と申します。
        iOSアプリを作る仕事をしています。
        インターネットでは @fromkk というアカウントで活動しているのでよかったらフォローしてください。
        カメラで写真を撮るのが好きです。
        """
    case .lastYear:
      return """
        ご存知の方もいるかもしれませんが、昨年はカメラマンとしてスタッフをしていました。
        今年は声がかからなかったので
        """
    case .apply:
      return "登壇者として申し込むことにしました"
    }
  }

  var transition: AnyTransition = AnyTransition(AwesomeTransition())
}

#Preview("initial") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<ProfileSlide.SlidePhase>(.initial)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        ProfileSlide()
      }
    )
  }
}

#Preview("fire") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<ProfileSlide.SlidePhase>(.lastYear)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        ProfileSlide()
      }
    )
  }
}


#Preview("apply") {
  PresentationView(slideSize: SlideSize.standard16_9) {
    let container = ObservableObjectContainer()
    _ = container.resolve {
      PhasedStateStore<ProfileSlide.SlidePhase>(.apply)
    }
    return SlideRouterView(
      slideIndexController: SlideIndexController(container: container) {
        ProfileSlide()
      }
    )
  }
}

