import SwiftUI
import SlideKit

@MainActor
struct SlideConfiguration {
    let size = SlideSize.standard16_9

    let slideIndexController = SlideIndexController {
        TitleSlide()
    }
}
