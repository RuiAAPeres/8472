import SwiftUI

extension View {
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
