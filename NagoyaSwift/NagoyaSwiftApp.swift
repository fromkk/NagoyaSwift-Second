import NagoyaSwiftSlides
import SlideKit
import SwiftUI

@main
struct NagoyaSwiftApp: App {
  private static let configuration = SlideConfiguration()

  var presentationContentView: some View {
    SlideRouterView(
      slideIndexController: Self.configuration.slideIndexController
    )
    .background(Color.white)
    .foregroundStyle(Color.black)
  }

  var body: some Scene {
    WindowGroup {
      PresentationView(slideSize: Self.configuration.size) {
        presentationContentView
      }
    }
    #if os(macOS)
      .setupAsPresentationWindow(
        Self.configuration.slideIndexController,
        openWindow: {}
      )
    #endif
  }
}
