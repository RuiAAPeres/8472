import SwiftUI

struct MainView: View {
    
    @ObservedObject private var viewModel: MainViewModel
    @State private var isLoginPresented = false
    @SwiftUI.Environment(\.presentationMode) var presentationMode
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            render(viewModel.state)
        }
        .onAppear(perform: viewModel.start)
    }
    
    func render(_ state: MainViewModel.State) -> some View {
        switch state {
        case .loading:
            return Text("It's loading...").eraseToAnyView()
        case .authenticated(_):
            return EmptyView().eraseToAnyView()
        case .unauthenticated:
            return Button(action: {
                self.isLoginPresented = true
            }, label: {
                Text("Login with Strava")
            })
                .sheet(isPresented: $isLoginPresented, content: {
                    WebView.init(request: URLRequest.init(url: URL.init(string: "https://developer.apple.com/documentation/webkit/wkwebview")!))
                }
            ).eraseToAnyView()
        }
    }
}




