import NagoyaSwiftSlides
import PDFKit
import SlideKit
import SwiftUI

@MainActor
struct SlidePDFExporter {
  let slideSize = SlideSize.standard16_9
  private static let webPageLoadTimeout: Duration = .seconds(10)
}

#if canImport(UIKit)
  import UIKit

  extension SlidePDFExporter {
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
        let tracker = WebPageLoadingTracker()

        let slideView = SlideScreen(slideSize: slideSize) {
          AnyView(slide)
        }
        .environment(\.slideIndexController, slideIndexController)
        .environment(\.webPageLoadingTracker, tracker)

        let hostingController = UIHostingController(rootView: slideView)
        hostingController.view.frame = pageRect.offsetBy(dx: 10000, dy: 10000)
        hostingController.view.bounds = pageRect
        hostingController.view.backgroundColor = .clear

        keyWindow?.addSubview(hostingController.view)
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()

        // WebContentView の makeUIView が呼ばれて load が開始されるまで待つ
        try? await Task.sleep(for: .milliseconds(300))

        // WebView のロード完了を待機（最大10秒）
        await waitForTracker(tracker)

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

    private func waitForTracker(_ tracker: WebPageLoadingTracker) async {
      let deadline = ContinuousClock.now + Self.webPageLoadTimeout
      while !tracker.isAllLoaded {
        guard ContinuousClock.now < deadline else { break }
        try? await Task.sleep(for: .milliseconds(100))
      }
    }
  }
#endif

#if os(macOS)
  import AppKit
  import UniformTypeIdentifiers

  extension SlidePDFExporter {
    func exportWithSavePanel(slideIndexController: SlideIndexController) async {
      let panel = NSSavePanel()
      panel.allowedContentTypes = [.pdf]
      panel.nameFieldStringValue = "NagoyaSwift_\(Int(Date().timeIntervalSince1970)).pdf"

      let response = await panel.begin()
      guard response == .OK, let url = panel.url else { return }

      guard let pdfData = await createPDFDataMac(slideIndexController: slideIndexController) else {
        return
      }

      try? pdfData.write(to: url)
    }

    private func createPDFDataMac(slideIndexController: SlideIndexController) async -> Data? {
      let pageRect = CGRect(origin: .zero, size: slideSize)

      let window = NSWindow(
        contentRect: NSRect(origin: CGPoint(x: -20000, y: -20000), size: slideSize),
        styleMask: .borderless,
        backing: .buffered,
        defer: false
      )

      var images: [NSImage] = []

      for slide in slideIndexController.slides {
        let tracker = WebPageLoadingTracker()

        let slideView = SlideScreen(slideSize: slideSize) {
          AnyView(slide)
        }
        .environment(\.slideIndexController, slideIndexController)
        .environment(\.webPageLoadingTracker, tracker)

        let hostingView = NSHostingView(rootView: slideView)
        hostingView.frame = pageRect
        window.contentView = hostingView
        window.orderBack(nil)

        // WebContentView の makeNSView が呼ばれて load が開始されるまで待つ
        try? await Task.sleep(for: .milliseconds(300))

        // WebView のロード完了を待機（最大10秒）
        await waitForTrackerMac(tracker)

        guard
          let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: pageRect)
        else { continue }
        hostingView.cacheDisplay(in: pageRect, to: bitmapRep)

        let image = NSImage(size: slideSize)
        image.addRepresentation(bitmapRep)
        images.append(image)
      }

      window.orderOut(nil)

      let pdfDocument = PDFDocument()
      for (index, image) in images.enumerated() {
        if let page = PDFPage(image: image) {
          pdfDocument.insert(page, at: index)
        }
      }

      return pdfDocument.dataRepresentation()
    }

    private func waitForTrackerMac(_ tracker: WebPageLoadingTracker) async {
      let deadline = ContinuousClock.now + Self.webPageLoadTimeout
      while !tracker.isAllLoaded {
        guard ContinuousClock.now < deadline else { break }
        try? await Task.sleep(for: .milliseconds(100))
      }
    }
  }
#endif
