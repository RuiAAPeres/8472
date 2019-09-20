import SwiftUI
import Combine
import Core
import StravaCore

class MainViewModel: ObservableObject {
    
    @Published var state: State = .loading
    let route: PassthroughSubject<Route, Never> = PassthroughSubject()
    
    private var disposables = Set<AnyCancellable>()
    private let session: SessionViewModel
    
    init(session: SessionViewModel) {
        self.session = session
        
        session.state
            .map(toMainViewState)
            .receive(on: DispatchQueue.main)
            .assign(to: \.state, on: self)
            .store(in: &disposables)
    }
    
    func start() {
        session.start()
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
