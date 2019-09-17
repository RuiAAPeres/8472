import SwiftUI

extension View {
    public var viewController: UIViewController {
        return UIHostingController(rootView: self)
    }
}
