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

struct Contacts: View {
    var body: some View {
        WebView(urlString: "https://bridgeberry.net/gold-vendor-list/")
            .navigationTitle("Contacts")
    }
}
struct Contacts_Previews: PreviewProvider {
    static var previews: some View{
        Contacts()
    }
}
