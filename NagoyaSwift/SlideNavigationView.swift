#if canImport(UIKit)
  import NagoyaSwiftSlides
  import SlideKit
  import SwiftUI

  struct SlideNavigationView: View {
    let configuration: SlideConfiguration
    @FocusState private var isFocused: Bool

    var body: some View {
      PresentationView(slideSize: configuration.size) {
        SlideRouterView(slideIndexController: configuration.slideIndexController)
      }
      .gesture(
        DragGesture(minimumDistance: 100)
          .onEnded { value in
            if value.translation.width < 100 {
              configuration.slideIndexController.forward()
            } else if value.translation.width > -100 {
              configuration.slideIndexController.back()
            }
          }
      )
      .focusable()
      .focusEffectDisabled(true)
      .focused($isFocused)
      .onKeyPress(.rightArrow) {
        Task { @MainActor in configuration.slideIndexController.forward() }
        return .handled
      }
      .onKeyPress(.leftArrow) {
        Task { @MainActor in configuration.slideIndexController.back() }
        return .handled
      }
      .onKeyPress(.space) {
        Task { @MainActor in configuration.slideIndexController.forward() }
        return .handled
      }
      .onAppear {
        isFocused = true
      }
    }
  }
#endif
