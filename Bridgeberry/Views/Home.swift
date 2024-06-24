import SwiftUI
import Foundation

struct Home: View {
    @State private var urls: [URLModel] = []

    var body: some View {
        NavigationView {
            List(urls) { urlModel in
                NavigationLink(destination: WebView(urlString: urlModel.url)) {
                    Text(urlModel.title)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadURLsFromJSON()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func loadURLsFromJSON() {
        guard let url = Bundle.main.url(forResource: "urls", withExtension: "json") else {
            print("Failed to locate urls.json in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            urls = try JSONDecoder().decode([URLModel].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct URLModel: Identifiable, Decodable {
    var id: String // Change type to String
    var title: String
    var url: String
}

