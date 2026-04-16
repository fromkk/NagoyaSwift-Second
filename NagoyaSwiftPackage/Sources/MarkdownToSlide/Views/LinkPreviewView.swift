import LinkPresentation
import SwiftUI

struct LinkPreviewView: View {
  let url: URL
  @State private var metadata: LPLinkMetadata?
  @State private var height: CGFloat = 80

  var body: some View {
    Group {
      if let metadata {
        LPLinkViewRepresentable(metadata: metadata, height: $height)
          .frame(maxWidth: .infinity)
          .frame(height: height)
      } else {
        ProgressView()
          .frame(maxWidth: .infinity, minHeight: 80)
      }
    }
    .task(id: url) {
      await fetchMetadata()
    }
  }

  @MainActor
  private func fetchMetadata() async {
    let provider = LPMetadataProvider()
    do {
      metadata = try await provider.startFetchingMetadata(for: url)
    } catch {
      let fallback = LPLinkMetadata()
      fallback.url = url
      metadata = fallback
    }
  }
}

private struct LPLinkViewRepresentable: UIViewRepresentable {
  let metadata: LPLinkMetadata
  @Binding var height: CGFloat

  func makeUIView(context: Context) -> LPLinkView {
    LPLinkView(metadata: metadata)
  }

  func updateUIView(_ view: LPLinkView, context: Context) {
    view.metadata = metadata
    DispatchQueue.main.async {
      height = view.intrinsicContentSize.height
    }
  }
}
