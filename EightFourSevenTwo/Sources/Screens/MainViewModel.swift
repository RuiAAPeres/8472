import SwiftUI
import Combine
import Core
import StravaCore

class MainViewModel: ObservableObject {
    
    @Published var state: State = .loading
    let route: PassthroughSubject<Route, Never> = PassthroughSubject()
    
    private var disposables = Set<AnyCancellable>()
    
    init(session: SessionViewModel) {
        session
            .state.map(toMainViewState)
            .assign(to: \.state, on: self)
            .store(in: &disposables)
    }
}

extension MainViewModel {
    enum State {
        case loading
        case authenticated(User)
        case unauthenticated
    }
    
    enum Route {
        case presentStravaLogin(with: URLRequest)
        case dismissStravaLogin
        case showFailure(CoreError)
    }
}

private func toMainViewState(_ state: SessionViewModel.State)
    -> MainViewModel.State {
        switch state {
        case .authenticatingStep1,
             .authenticatingStep2,
             .checkCredentials,
             .authenticated:
            return .loading
        case .unauthenticated,
             .failedStep1,
             .failedStep2:
            return .unauthenticated
        }
}
