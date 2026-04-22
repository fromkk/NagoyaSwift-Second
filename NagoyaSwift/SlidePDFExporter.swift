#if canImport(UIKit)
  import PDFKit
  import SlideKit
  import SwiftUI
  import UIKit

  @MainActor
  struct SlidePDFExporter {
    private let slideSize = SlideSize.standard16_9

    func export(slideIndexController: SlideIndexController) async -> URL? {
      guard let pdfData = createPDFData(slideIndexController: slideIndexController) else {
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

    private func createPDFData(slideIndexController: SlideIndexController) -> Data? {
      let pdfData = NSMutableData()
      UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: slideSize), nil)

      for slide in slideIndexController.slides {
        let slideView = SlideScreen(slideSize: slideSize) {
          AnyView(slide)
        }
        .environment(\.slideIndexController, slideIndexController)
        UIGraphicsBeginPDFPageWithInfo(CGRect(origin: .zero, size: slideSize), nil)
        renderViewToPDF(slideView)
      }

      UIGraphicsEndPDFContext()
      return pdfData.length > 0 ? pdfData as Data : nil
    }

    private func renderViewToPDF<V: View>(_ view: V) {
      let hostingController = UIHostingController(rootView: view)
      let targetRect = CGRect(origin: .zero, size: slideSize)
      hostingController.view.frame = targetRect
      hostingController.view.bounds = targetRect
      hostingController.view.backgroundColor = .clear

      let keyWindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }

      if let window = keyWindow {
        hostingController.view.frame = targetRect.offsetBy(dx: 10000, dy: 10000)
        window.addSubview(hostingController.view)
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        hostingController.view.frame = targetRect
      } else {
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
      }

      let format = UIGraphicsImageRendererFormat()
      format.scale = 2.0
      format.opaque = false
      let renderer = UIGraphicsImageRenderer(size: slideSize, format: format)
      let image = renderer.image { context in
        hostingController.view.layer.render(in: context.cgContext)
      }

      hostingController.view.removeFromSuperview()
      image.draw(in: targetRect)
    }
  }
#endif
