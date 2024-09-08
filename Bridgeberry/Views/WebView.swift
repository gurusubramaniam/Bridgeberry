import SwiftUI
import WebKit

struct WebView: View {
    let urlString: String

    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            WebViewRepresentable(urlString: urlString, isLoading: $isLoading)
                .edgesIgnoringSafeArea(.all)
            if isLoading {
                VStack {
                    Text("Loading...")
                        .font(.headline)
                        .foregroundColor(.gray)
                    ProgressView()
                }
            }
        }
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String
    @Binding var isLoading: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad // Use cached data if available
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update UI if needed
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable

        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }

        // No need for manual HTTP status check here
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow) // Allow all navigation actions
        }
    }
}

