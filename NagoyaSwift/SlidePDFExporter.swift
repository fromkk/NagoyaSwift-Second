#if canImport(UIKit)
  import NagoyaSwiftSlides
  import PDFKit
  import SlideKit
  import SwiftUI
  import UIKit
  import WebKit

  @MainActor
  struct SlidePDFExporter {
    private let slideSize = SlideSize.standard16_9
    private static let webPageLoadTimeout: Duration = .seconds(10)

    func export(slideIndexController: SlideIndexController) async -> URL? {
      guard let pdfData = await createPDFData(slideIndexController: slideIndexController) else {
        return nil
      }

      let tempURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("NagoyaSwift_\(Int(Date().timeIntervalSince1970)).pdf")
      do {
        try pdfData.write(to: tempURL)
        return tempURL
      } catch {
        return nil
      }
    }

    private func createPDFData(slideIndexController: SlideIndexController) async -> Data? {
      let pdfData = NSMutableData()
      let pageRect = CGRect(origin: .zero, size: slideSize)

      let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }

      var images: [UIImage] = []
      for slide in slideIndexController.slides {
        let slideView = SlideScreen(slideSize: slideSize) {
          AnyView(slide)
        }
        .environment(\.slideIndexController, slideIndexController)

        let hostingController = UIHostingController(rootView: slideView)
        hostingController.view.frame = pageRect.offsetBy(dx: 10000, dy: 10000)
        hostingController.view.bounds = pageRect
        hostingController.view.backgroundColor = .clear

        keyWindow?.addSubview(hostingController.view)
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()

        // .task モディファイアが発火して WebPage.load() が呼ばれるまで待つ
        try? await Task.sleep(for: .milliseconds(300))

        // WebPageProviding に準拠していればロード完了を待機（最大10秒）
        if let provider = slide as? any WebPageProviding {
          await waitForWebPages(provider.webPages)
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2.0
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: slideSize, format: format)
        let image = renderer.image { _ in
          hostingController.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        images.append(image)

        hostingController.view.removeFromSuperview()
      }

      UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
      for image in images {
        UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
        image.draw(in: pageRect)
      }
      UIGraphicsEndPDFContext()

      return pdfData.length > 0 ? pdfData as Data : nil
    }

    /// WebPage のロード完了を待機する（ロード中でなければ即リターン、最大10秒でタイムアウト）
    private func waitForWebPages(_ webPages: [WebPage]) async {
      let loadingPages = webPages.filter { $0.isLoading }
      guard !loadingPages.isEmpty else { return }

      let deadline = ContinuousClock.now + Self.webPageLoadTimeout
      while loadingPages.contains(where: { $0.isLoading }) {
        guard ContinuousClock.now < deadline else { break }
        try? await Task.sleep(for: .milliseconds(100))
      }
    }
  }
#endif
