import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var isLoading = true
    @State private var notifications: [NotificationModel] = []

    var body: some View {
        Group {
            if isLoading {
                Image("Bridgeberry_light")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("Loading...")
                    .onAppear {
                        loadNotificationsFromJSON()
                        requestNotificationPermissions()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    }
            } else {
                TabView {
                    Home().tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    Contacts().tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Contacts")
                    }
                    Weather().tabItem {
                        Image(systemName: "cloud.sun.fill")
                        Text("Weather")
                    }
                }
            }
        }
    }

    func loadNotificationsFromJSON() {
        guard let url = Bundle.main.url(forResource: "notifications", withExtension: "json") else {
            print("Failed to locate notifications.json in app bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            notifications = try decoder.decode([NotificationModel].self, from: data)
            print("Loaded notifications: \(notifications)")
            scheduleNotifications()
        } catch {
            print("Error decoding notifications JSON: \(error.localizedDescription)")
        }
    }

    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    func scheduleNotifications() {
        for notification in notifications {
            guard let date = notification.date else {
                print("Invalid date format for notification: \(notification.title)")
                continue
            }

            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = UNNotificationSound.default

            // Schedule notification for the actual date in the JSON
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Notification scheduled successfully: \(notification.title) at \(date)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
