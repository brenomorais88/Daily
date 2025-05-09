//
//  Event.swift
//  Daily
//
//  Created by Breno Morais on 17/04/25.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var eventGroupID: String? // id do evento pai
    var title: String
    var detail: String?
    var initDate: String
    var finishDate: String
    var time: String?
    var type: Int
    var recurrence: Int
    var userID: String?
    var enableAlarm: Bool?
    var complete: Bool

    var initDateAsDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: initDate) ?? Date()
    }

    var timeAsDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time ?? "") ?? Date()
    }
}

