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

    func fetchTodayEvents(completion: @escaping ([Event]) -> Void) {

        DebugEventSeeder().seedFakeEvents(count: 200)

        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        print(userId)

        let today = formatDate(Date())

        db.collection("users")
            .document(userId)
            .collection("events")
            .whereField("initDate", isEqualTo: today)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erro ao buscar eventos:", error.localizedDescription)
                    completion([])
                    return
                }

                let events = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Event.self)
                } ?? []

                completion(events)
            }
    }


    func createEvent(event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."])))
            return
        }

        do {
            _ = try db.collection("users")
                .document(userId)
                .collection("events")
                .addDocument(from: event)

            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
