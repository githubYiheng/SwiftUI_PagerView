import SwiftUI

public struct PagerView<Content: View & Identifiable>: View {

    @Binding
    public var index: Int
    
    public var pages: [Content]
    
    @State
    private var offset: CGFloat = 0
    
    @State
    private var isGestureActive: Bool = false

    public init(_ index: Binding<Int>, _ pages: [Content]) {
        self._index = index
        self.pages = pages
    }
    
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
            .content.offset(y: self.isGestureActive ? self.offset : -geometry.size.height * CGFloat(self.index))
            .gesture(DragGesture().onChanged({ value in
                self.isGestureActive = true
                self.offset = value.translation.height + -geometry.size.height * CGFloat(self.index)
            }).onEnded({ value in
                if -value.predictedEndTranslation.height > geometry.size.height / 2, self.index < self.pages.endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.height > geometry.size.height / 2, self.index > 0 {
                    self.index -= 1
                }
                withAnimation { self.offset = -geometry.size.height * CGFloat(self.index) }
                DispatchQueue.main.async { self.isGestureActive = false }
            }))
        }
    }
}
