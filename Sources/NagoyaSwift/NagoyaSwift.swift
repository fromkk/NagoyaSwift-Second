import SwiftUI
import SlideKit

@main
struct NagoyaSwiftApp: App {
    private static let configuration = SlideConfiguration()

    var presentationContentView: some View {
        SlideRouterView(slideIndexController: Self.configuration.slideIndexController)
            .foregroundColor(.white)
            .background(.black)
    }

    var body: some Scene {
        WindowGroup {
            PresentationView(slideSize: Self.configuration.size) {
                presentationContentView
            }
        }
        #if os(macOS)
        .setupAsPresentationWindow(Self.configuration.slideIndexController, openWindow: {})
        #endif
    }
}
