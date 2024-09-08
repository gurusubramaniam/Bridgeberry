//
//  BridgeberryApp.swift
//  Bridgeberry
//
//  Created by Guru S on 6/10/24.
//

import SwiftUI

@main
struct Bridgeberry: App {
    let prefetcher = WebViewPrefetcher()

        init() {
            // Prefetch URLs
            prefetcher.prefetchURLsFromJSON()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
