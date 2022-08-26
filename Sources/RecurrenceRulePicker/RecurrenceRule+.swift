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
    
    public var localizedString: String {
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).languageCode ?? "en"
        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) else {
            fatalError()
        }
        return NSLocalizedString(self.localizedStringKey, tableName: nil, bundle: bundle, value: self.localizedStringKey, comment: self.localizedStringKey)
    }
    
    public var localizedStringKey: String {
        switch self {
            case .daily: return "frequency.day"
            case .weekly: return "frequency.week"
            case .monthly: return "frequency.month"
            case .yearly: return "frequency.year"
        }
    }
}
