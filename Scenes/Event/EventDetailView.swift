//
//  EventDetailView.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event? = nil

    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var hasChanges = false

    private var isNewEvent: Bool {
        return event == nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Título", text: $title)
                .font(.title2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: title) { _ in hasChanges = true }

            TextField("Detalhes", text: $detail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: detail) { _ in hasChanges = true }

            DatePicker("Data", selection: $date, displayedComponents: .date)
                .onChange(of: date) { _ in hasChanges = true }

            DatePicker("Horário", selection: $time, displayedComponents: .hourAndMinute)
                .onChange(of: time) { _ in hasChanges = true }

            if isNewEvent {
                Button("Salvar") {
                    saveEvent()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .padding(.top)
            } else {
                if let recurrence = event?.recurrence {
                    Text("Recorrência: \(recurrenceDescription(recurrence))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if hasChanges {
                    Button("Salvar alterações") {
                        updateEvent()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(isNewEvent ? "Novo Evento" : "Detalhes")
        .onAppear {
            if let event {
                title = event.title
                detail = event.detail ?? ""
                date = event.initDateAsDate
                time = event.timeAsDate
            }
        }
    }

    private func saveEvent() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let newEvent = Event(
            title: title,
            detail: detail,
            initDate: formatter.string(from: date),
            finishDate: formatter.string(from: date),
            time: formattedHour(time),
            type: 1,
            recurrence: 1,
            complete: false
        )

        print("Novo evento salvo: \(newEvent)")
        // Ex: salvar no Firestore ou passar via delegate
    }

    private func updateEvent() {
        guard let original = event else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let updated = Event(
            id: original.id,
            title: title,
            detail: detail,
            initDate: formatter.string(from: date),
            finishDate: formatter.string(from: date),
            time: formattedHour(time),
            type: original.type,
            recurrence: original.recurrence,
            complete: false
        )

        print("Evento atualizado: \(updated)")
        // Ex: atualizar no Firestore ou notificar via closure/delegate
        hasChanges = false
    }

    private func formattedHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private func recurrenceDescription(_ value: Int) -> String {
        switch value {
        case 1: return "Nenhuma"
        case 2: return "Diária"
        case 3: return "Semanal"
        case 4: return "Mensal"
        default: return "Desconhecida"
        }
    }
}
