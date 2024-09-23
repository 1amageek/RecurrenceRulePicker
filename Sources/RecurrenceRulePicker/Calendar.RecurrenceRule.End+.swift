//
//  Calendar.RecurrenceRule.End+.swift
//  RecurrenceRulePicker
//
//  Created by Norikazu Muramoto on 2024/09/24.
//

import Foundation


extension Calendar.RecurrenceRule.End {
    
    public var occurrences: Int? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let occurrences = jsonObject["occurrences"] as? Int else {
            return nil
        }
        return occurrences
    }
    
    public var date: Date? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject: [String: Any] = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let timestamp = jsonObject["until"] as? TimeInterval else {
            return nil
        }
        let date = Date(timeIntervalSinceReferenceDate: timestamp)
        return date
    }
}
