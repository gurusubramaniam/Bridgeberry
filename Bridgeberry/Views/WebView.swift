import SwiftUI
import WebKit

struct WebView: View {
    let urlString: String

    var body: some View {
        WebViewRepresentable(urlString: urlString)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update UI if needed
    }
}
