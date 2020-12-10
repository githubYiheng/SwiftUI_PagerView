import SwiftUI

public struct PagerView<Content: View & Identifiable>: View {

    @Binding
    public var index: Int
    
    @State
    private var offset: CGFloat = 0
    
    @State
    private var isGestureActive: Bool = false

    // 1
    private var pages: [Content]

    public var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: nil, height: geometry.size.height)
                    }
                }
            }
            // 2
            .content.offset(y: self.isGestureActive ? self.offset : -geometry.size.height * CGFloat(self.index))
            .gesture(DragGesture().onChanged({ value in
                // 4
                self.isGestureActive = true
                // 5
                self.offset = value.translation.height + -geometry.size.height * CGFloat(self.index)
            }).onEnded({ value in
                if -value.predictedEndTranslation.height > geometry.size.height / 2, self.index < self.pages.endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.height > geometry.size.height / 2, self.index > 0 {
                    self.index -= 1
                }
                // 6
                withAnimation { self.offset = -geometry.size.height * CGFloat(self.index) }
                // 7
                DispatchQueue.main.async { self.isGestureActive = false }
            }))
        }
    }
}
