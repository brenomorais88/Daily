//
//  EventDetailView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.title)
                .font(.largeTitle)
            Text(event.detail ?? "")
//            Text("Horário: \(formattedHour(event.startTime ?? Date())")
            Spacer()
        }
        .padding()
        .navigationTitle("Detalhes")
    }

    private func formattedHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
//    EventDetailView(event: Event(
//        id: "1",
//        title: "Reunião",
//        description: "Reunião com o time",
//        date: Date(),
//        startTime: Date()
//    ))
}
