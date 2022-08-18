//
//  RecurrenceRule+.swift
//  
//
//  Created by Norikazu Muramoto on 2022/08/18.
//

import Foundation
import SwiftUI
import RecurrenceRule

extension RecurrenceRule.Frequency {
    
    public var localizedStringKey: LocalizedStringKey {
        switch self {
            case .daily: return "frequency.day"
            case .weekly: return "frequency.week"
            case .monthly: return "frequency.month"
            case .yearly: return "frequency.year"
        }
    }
}
