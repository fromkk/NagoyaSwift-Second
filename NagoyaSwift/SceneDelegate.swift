#if canImport(UIKit)
  import MarkdownToView
  import NagoyaSwiftSlides
  import OSLog
  import SlideKit
  import SwiftUI
  import UIKit

  class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let logger = Logger(
      subsystem: Bundle.main.bundleIdentifier!,
      category: "AppDelegate"
    )

    let theme: MarkdownToView.SlideTheme = .default
    var window: UIWindow?

    func scene(
      _ scene: UIScene,
      willConnectTo session: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
    ) {
      logger.info("\(#function)")
      guard
        let windowScene = scene as? UIWindowScene,
        let configuration = (UIApplication.shared.delegate as? AppDelegate)?
          .configuration
      else {
        return
      }

      window = UIWindow(windowScene: windowScene)
      window?.rootViewController = UIHostingController(
        rootView: SlideNavigationView(configuration: configuration)
          .slideTheme(theme)
      )
      window?.makeKeyAndVisible()
    }
  }
#endif
