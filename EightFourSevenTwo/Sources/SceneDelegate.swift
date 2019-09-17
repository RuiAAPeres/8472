import UIKit
import SwiftUI
import Combine
import Overture
import Functional
import Core
import StravaCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let stravaURLCode: PassthroughSubject<StravaCode?, Never> = PassthroughSubject()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.makeKeyAndVisible()
            
            window.rootViewController = AppRouting.rootView().viewController
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        let urls = URLContexts.compactMap { $0.url }
        guard let url = urls.first else { return }
        
        let someCode =
            URLComponents(url: url, resolvingAgainstBaseURL: true)
                ?|> \URLComponents.queryItems
                ?|> curry(extract)("code")
        
        stravaURLCode.send(someCode)
    }
}
