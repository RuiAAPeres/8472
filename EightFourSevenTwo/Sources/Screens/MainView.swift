import SwiftUI
import WebKit

struct MainView: View {
    
    @ObservedObject private var viewModel: MainViewModel
    @State private var isLoginPresented = false
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button.init(action: {
            print(self.viewModel.state)
            self.isLoginPresented = true
        }, label: {
            Text("Login with Strava")
        })
        .sheet(isPresented: $isLoginPresented, content: {
            MyWebView.init(request: URLRequest.init(url: URL.init(string: "https://developer.apple.com/documentation/webkit/wkwebview")!))
        }
        )
    }
}

struct MyWebView: UIViewRepresentable {
    
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func makeUIView(context: UIViewRepresentableContext<MyWebView>) -> WKWebView {
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {}
}
