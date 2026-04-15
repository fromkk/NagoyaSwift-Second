#if canImport(UIKit)
  import NagoyaSwiftSlides
  import SlideKit
  import SwiftUI
  import UIKit

  final class ExternalSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
    ) {
      guard
        let windowScene = scene as? UIWindowScene,
        let configuration = (UIApplication.shared.delegate as? AppDelegate)?.configuration
      else {
        return
      }

      let contentView = PresentationView(slideSize: configuration.size) {
        SlideRouterView(slideIndexController: configuration.slideIndexController)
      }

      window = UIWindow(windowScene: windowScene)
      window?.rootViewController = UIHostingController(rootView: contentView)
      window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }
  }
#endif
