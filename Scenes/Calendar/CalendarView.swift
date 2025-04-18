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

    var body: some View {
        NavigationStack {
//            VStack(spacing: 60) {
                ElegantCalendarView(calendarManager: viewModel.calendarManager)
                    .frame(height: 200)
                    .environmentObject(viewModel.calendarManager)

//                HStack {
//                    Text("Eventos de \(viewModel.formattedSelectedDate)")
//                        .font(.headline)
//                        .padding(.leading)
//                    Spacer()
//                }
//                .padding(.vertical, 8)
//
//                if viewModel.events.isEmpty {
//                    Spacer()
//                    Text("Nenhum evento para este dia.")
//                        .foregroundColor(.gray)
//                    Spacer()
//                } else {
//                    List(viewModel.events) { event in
//                        NavigationLink(destination: EventDetailView(event: event)) {
//                            VStack(alignment: .leading) {
//                                Text(event.title)
//                                if let time = event.time {
//                                    Text(time)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                    .listStyle(.plain)
//                }
//            }
//            .navigationTitle("Calendário")
//            .navigationBarTitleDisplayMode(.inline)
//            .task {
//                if let date = viewModel.calendarManager.selectedDate {
//                    viewModel.onDateChanged(to: date)
//                } else {
//                    viewModel.onDateChanged(to: viewModel.selectedDate)
//                }
//            }
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
                }
            }
            .navigationTitle("Calendário")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if let date = viewModel.calendarManager.selectedDate {
                    viewModel.onDateChanged(to: date)
                } else {
                    viewModel.onDateChanged(to: viewModel.selectedDate)
                }
            }
        }
    }
}
