//
//  DataHelpers.swift
//  Daily
//
//  Created by Breno Morais on 09/05/25.
//

// Helpers

import UIKit

class DataHelpers {

    static var todayFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func dateFromString(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: str) ?? Date.distantPast
    }

    static func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        let cal = Calendar.current
        return cal.component(.day, from: d1) == cal.component(.day, from: d2) &&
               cal.component(.month, from: d1) == cal.component(.month, from: d2) &&
               cal.component(.year, from: d1) == cal.component(.year, from: d2)
    }

    static func isLastDayOfMonth(_ date: Date) -> Bool {
        let cal = Calendar.current
        let day = cal.component(.day, from: date)
        let range = cal.range(of: .day, in: .month, for: date)
        return day == range?.count
    }
    
}

