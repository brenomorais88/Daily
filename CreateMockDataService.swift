//
//  CreateMockDataService.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestore

class DebugEventSeeder {
    let db = Firestore.firestore()

    func seedFakeEvents(count: Int = 0) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Usuário não autenticado.")
            return
        }

        let titles = ["Reunião", "Consulta", "Pagamento", "Academia", "Aniversário", "Lembrete", "Projeto", "Check-in", "Almoço", "Curso"]
        let details = ["Importante", "Com cliente", "Pagar via PIX", "Trabalho em equipe", "Evento pessoal", "Agenda cheia", "Tarefa crítica", "Revisar escopo", nil]

        let eventGroupID: String = generateUniqueId()

        for i in 1...count {
            let title = titles.randomElement() ?? "Evento"
            let detail = details.randomElement() ?? nil
            let date = randomDate()
            let time = String(format: "%02d:%02d", Int.random(in: 8...18), [0, 15, 30, 45].randomElement() ?? 0)

            let event = Event(
                id: nil,
                eventGroupID: eventGroupID,
                title: "\(title) \(i)",
                detail: detail,
                initDate: date,
                finishDate: date,
                time: time,
                type: Int.random(in: 1...3),
                recurrence: Int.random(in: 0...3),
                userID: uid,
                enableAlarm: false,
                complete: false
            )

            do {
                try db.collection("events")
                    .addDocument(from: event)
                print("✅ Evento \(i) criado")
            } catch {
                print("❌ Erro ao criar evento \(i):", error.localizedDescription)
            }
        }
    }

    private func randomDate(forMonth month: Int = 5, year: Int = 2025) -> String {
        var components = DateComponents()
        components.year = year
        components.month = month

        // Dias seguros por mês
        let daysInMonth: [Int: Int] = [
            1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30,
            7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31
        ]

        // Detectar se o ano é bissexto
        let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)

        // Ajustar fevereiro
        var maxDay = daysInMonth[month] ?? 28
        if month == 2 && isLeapYear {
            maxDay = 29
        }

        components.day = Int.random(in: 1...maxDay)

        if let date = Calendar.current.date(from: components) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }

        return "\(year)-\(String(format: "%02d", month))-01" // fallback
    }

    func randomAlphaNumeric(length: Int) -> String {
        let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return String((0..<length).compactMap { _ in chars.randomElement() })
    }

    /// Gera o ID no formato: yyyyMMddHHmmss + 10 chars aleatórios
    func generateUniqueId() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "yyyyMMddHHmmss"   // ou ajuste para incluir milissegundos: yyyyMMddHHmmssSSS
        let dateString = formatter.string(from: Date())
        let randomPart = randomAlphaNumeric(length: 10)
        return dateString + randomPart
    }
}
