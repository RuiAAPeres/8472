import StravaCore
import Functional

enum AppRouting {}

extension AppRouting {
    static func rootView() -> MainView {
        
        let authentication = StravaAuthenticationBusinessController(
            connectable: AppEnvironment.current.connectable
        )
        
        let sessionViewModel = SessionViewModel(
            authentication: authentication,
            storage: AppEnvironment.current.userStorage,
            stravaURLCode: AppEnvironment.current.stravaURLCode)
    
        return sessionViewModel |> MainViewModel.init >>> MainView.init
    }
}

