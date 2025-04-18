//
//  HomeViewModel.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []

    private let service = EventService()

    init() {
        loadTodayEvents()
    }

    func loadTodayEvents() {
        service.fetchFilteredEvents { events in
            DispatchQueue.main.async {
                self.events = events.sorted(by: { ($0.time ?? "") < ($1.time ?? "") })
            }
        }
    }

    var todayFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}
