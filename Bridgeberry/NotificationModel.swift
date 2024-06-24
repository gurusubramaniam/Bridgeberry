//
//  NotificationModel.swift
//  Bridgeberry
//
//  Created by Guru S on 6/20/24.
//

import Foundation
struct NotificationModel: Codable, Identifiable {
    let id: String
    let title: String
    let body: String
    let date: Date?

    enum CodingKeys: String, CodingKey {
        case id, title, body, date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        
        // Date handling from ISO8601 format string
        let dateString = try container.decode(String.self, forKey: .date)
        date = DateFormatter.iso8601Full.date(from: dateString)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
