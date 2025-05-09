//
//  CalendarViewModel.swift
//  Daily
//
//  Created by Breno Morais on 18/04/25.
//

import Foundation
import ElegantCalendar
import SwiftUICore

class CalendarViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var formattedSelectedDate: String = ""
    @Published var selectedDate: Date = Date()
    @Published var isScrolling: Bool = false

    let calendarManager: ElegantCalendarManager
    private let eventService = EventService()

    init() {
        let configuration = CalendarConfiguration(startDate: Date().addingTimeInterval(-60*60*24*365),
                                                  endDate: Date().addingTimeInterval(60*60*24*365))
        self.calendarManager = ElegantCalendarManager(configuration: configuration,
                                                      initialMonth: Date())
        self.calendarManager.delegate = self
        self.calendarManager.datasource = self
    }

    func onDateChanged(to date: Date) {
        selectedDate = date
        formattedSelectedDate = formatDateLabel(date)
        eventService.fetchFilteredEvents(searchDate: date) { events in
            DispatchQueue.main.async {
                self.events = events
            }
        }
    }

    private func formatDateLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

extension CalendarViewModel: ElegantCalendarDelegate, ElegantCalendarDataSource {
    func calendar(didSelectDay date: Date) {
        onDateChanged(to: date)
    }

    internal func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let view = CalendarEventsView(viewModel: self)
        return AnyView(view)
    }
}
