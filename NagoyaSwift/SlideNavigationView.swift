#if canImport(UIKit)
  import NagoyaSwiftSlides
  import SlideKit
  import SwiftUI

  struct SlideNavigationView: View {
    let configuration: SlideConfiguration
    var store: AppStore?
    @ObservedObject private var slideIndexController: SlideIndexController
    @FocusState private var isFocused: Bool

    init(configuration: SlideConfiguration, store: AppStore? = nil) {
      self.configuration = configuration
      self.store = store
      self.slideIndexController = configuration.slideIndexController
    }

    var body: some View {
      if let store, store.hasExternalDisplay {
        presenterView(store: store)
      } else {
        slideView
      }
    }

    // MARK: - Full-screen slide view (no external display)

    private var slideView: some View {
      PresentationView(slideSize: configuration.size) {
        SlideRouterView(slideIndexController: slideIndexController)
      }
      .gesture(navigationGesture)
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

    // MARK: - Presenter view (external display connected)

    private func presenterView(store: AppStore) -> some View {
      NavigationStack {
        VStack(spacing: 0) {
          PresentationView(slideSize: configuration.size) {
            SlideRouterView(slideIndexController: slideIndexController)
          }
          .aspectRatio(16 / 9, contentMode: .fit)
          .padding()

          ScrollView {
            Text(slideIndexController.currentScript.isEmpty ? "（スピーカーノートなし）" : slideIndexController.currentScript)
              .frame(maxWidth: .infinity, alignment: .leading)
              .multilineTextAlignment(.leading)
              .padding()
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .gesture(navigationGesture)
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
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button {
              store.isMirroring.toggle()
            } label: {
              Label(
                store.isMirroring ? "Presentation Mode" : "Mirror Mode",
                systemImage: store.isMirroring ? "rectangle.on.rectangle" : "rectangle.2.swap"
              )
            }
          }

          ToolbarItem(placement: .bottomBar) {
            Button {
              configuration.slideIndexController.back()
            } label: {
              Label("Back", systemImage: "chevron.backward")
            }
          }

          ToolbarItem(placement: .bottomBar) {
            Text(
              "\(slideIndexController.currentIndex + 1) / \(slideIndexController.slides.count)"
            )
            .monospacedDigit()
          }

          ToolbarItem(placement: .bottomBar) {
            Button {
              configuration.slideIndexController.forward()
            } label: {
              Label("Next", systemImage: "chevron.forward")
            }
          }
        }
      }
    }

    // MARK: - Shared gesture

    private var navigationGesture: some Gesture {
      DragGesture(minimumDistance: 100)
        .onEnded { value in
          if value.translation.width < 100 {
            configuration.slideIndexController.forward()
          } else if value.translation.width > -100 {
            configuration.slideIndexController.back()
          }
        }
    }
  }
#endif
