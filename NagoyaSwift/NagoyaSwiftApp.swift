import MarkdownToSlide
import NagoyaSwiftSlides
import SlideKit
import SwiftUI

#if !canImport(UIKit)
  @main
#endif
struct NagoyaSwiftApp: App {
  private static let configuration = SlideConfiguration()
  let theme: MarkdownToSlide.SlideTheme = .default

  var presentationContentView: some View {
    SlideRouterView(
      slideIndexController: Self.configuration.slideIndexController
    )
  }

  var body: some Scene {
    WindowGroup {
      PresentationView(slideSize: Self.configuration.size) {
        ZStack {
          theme.backgroundColor
          presentationContentView
        }
      }
      .slideTheme(theme)
    }
    #if os(macOS)
      .setupAsPresentationWindow(
        Self.configuration.slideIndexController,
        openWindow: {}
      )
    #endif
  }
}
