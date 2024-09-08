import WebKit

class WebViewPrefetcher: NSObject {
    private var webView: WKWebView?

    struct URLInfo: Codable {
        let id: String
        let title: String
        let url: String
    }

    override init() {
        super.init()
        setupCache()
    }

    private func setupCache() {
        // Set up a cache with a 50MB memory capacity and a 100MB disk capacity
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 100 * 1024 * 1024 // 100 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "webCache")
        URLCache.shared = cache
    }

    func prefetchURLsFromJSON() {
        guard let path = Bundle.main.path(forResource: "urls", ofType: "json") else {
            print("Error: URLs file not found.")
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let urlInfos = try JSONDecoder().decode([URLInfo].self, from: data)
            let urls = urlInfos.map { $0.url }
            prefetchURLs(urls)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func prefetchURLs(_ urls: [String]) {
        if webView == nil {
            let webViewConfiguration = WKWebViewConfiguration()
            webViewConfiguration.allowsInlineMediaPlayback = true
            webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
            webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
            webView?.navigationDelegate = self
        }

        urls.forEach { urlString in
            guard let url = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            webView?.load(request)
        }
    }
}

extension WebViewPrefetcher: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Handle any post-loading actions, if necessary
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Handle loading errors, if necessary
    }
}
