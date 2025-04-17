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
    var title: String
    var detail: String?
    var initDate: String
    var finishDate: String
    var time: String?
    var type: Int
    var recurrence: Int
}
