//
//  CalendarView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI
import ElegantCalendar

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var isInnerScrolling = false
    
    var body: some View {
        NavigationStack {
            ElegantCalendarView(calendarManager: viewModel.calendarManager)
                .vertical()
                .frame(height: 200)
                .environmentObject(viewModel.calendarManager)
                .allowsHitTesting(!self.viewModel.isScrolling)

        }
    }
}

struct CalendarEventsView: View {
    private let viewModel: CalendarViewModel

    public init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                if viewModel.events.isEmpty {
                    Spacer()
                    Text("Nenhum evento para este dia.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                if let time = event.time {
                                    Text(time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { _ in }
                    )
                }
            }
        }
    }
}
