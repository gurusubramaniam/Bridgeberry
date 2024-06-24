//
//  Weather.swift
//  Bridgeberry
//
//  Created by Guru S on 6/24/24.
//
//
//  Contacts.swift
//  Bridgeberry
//
//  Created by Guru S on 6/10/24.
//

// Contacts.swift
import SwiftUI
import WebKit

// Contacts.swift
import SwiftUI

struct Weather: View {
    var body: some View {
        WebView(urlString: "https://tempestwx.com/station/73221")
            .navigationTitle("Weather")
            .edgesIgnoringSafeArea(.all)
    }
}
struct Weather_preview: PreviewProvider {
    static var previews: some View{
        Weather()
    }
}
