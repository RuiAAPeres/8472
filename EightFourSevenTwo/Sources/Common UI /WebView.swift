import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
    }
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
}

