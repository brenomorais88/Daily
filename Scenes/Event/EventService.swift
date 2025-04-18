//
//  EventService.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class EventService {
    private let db = Firestore.firestore()

    func fetchFilteredEvents(searchDate: Date = Date(), completion: @escaping ([Event]) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        let dateString = formatDate(searchDate)
        let dateWeekday = Calendar.current.component(.weekday, from: searchDate)
        let dateDay = Calendar.current.component(.day, from: searchDate)
        let isTodayLastDayOfMonth = isLastDayOfMonth(searchDate)

        db.collection("events")
            .whereField("userID", isEqualTo: currentUserId)
            .whereField("finishDate", isGreaterThanOrEqualTo: dateString)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erro ao buscar eventos:", error.localizedDescription)
                    completion([])
                    return
                }

                let allEvents = snapshot?.documents.compactMap { try? $0.data(as: Event.self) } ?? []

                let filtered = allEvents.filter { event in
                    let recurrence = event.recurrence
                    let initDate = self.dateFromString(event.initDate)

                    switch recurrence {
                    case 0:
                        // Nenhuma recorrência: incluir apenas se initDate for hoje
                        return self.isSameDay(initDate, searchDate)

                    case 1:
                        // Diária: sempre retorna
                        return true

                    case 2:
                        // Semanal: incluir se o dia da semana for o mesmo
                        return Calendar.current.component(.weekday, from: initDate) == dateWeekday

                    case 3:
                        // Mensal:
                        let initDay = Calendar.current.component(.day, from: initDate)
                        if initDay == dateDay {
                            return true
                        }
                        if initDay >= 28 && isTodayLastDayOfMonth {
                            return true // regra especial para dia 31
                        }
                        return false

                    default:
                        return false
                    }
                }

                completion(filtered.sorted(by: { ($0.time ?? "") < ($1.time ?? "") }))
            }
    }

    // Helpers

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func dateFromString(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: str) ?? Date.distantPast
    }

    private func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        let cal = Calendar.current
        return cal.component(.day, from: d1) == cal.component(.day, from: d2) &&
               cal.component(.month, from: d1) == cal.component(.month, from: d2) &&
               cal.component(.year, from: d1) == cal.component(.year, from: d2)
    }

    private func isLastDayOfMonth(_ date: Date) -> Bool {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        let range = cal.range(of: .day, in: .month, for: date)
        return day == range?.count
    }
}

