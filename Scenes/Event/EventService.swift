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

        let dateString = DataHelpers.formatDate(searchDate)

        db.collection("events")
            .whereField("userID", isEqualTo: currentUserId)
            .whereField("initDate", isEqualTo: dateString)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Erro ao buscar eventos:", error.localizedDescription)
                    completion([])
                    return
                }

                let allEvents = snapshot?.documents.compactMap { try? $0.data(as: Event.self) } ?? []
                completion(allEvents)
            }
    }

    
}

