import SwiftUI
import SlideKit

@Slide
struct TitleSlide: View {
    var shouldHideIndex: Bool { true }

    var body: some View {
        VStack(spacing: 24) {
            Text("Nagoya.swift #2")
                .font(.system(size: 120, weight: .bold))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
