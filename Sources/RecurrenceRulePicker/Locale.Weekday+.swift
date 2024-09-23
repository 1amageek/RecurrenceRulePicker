//
//  Locale.Weekday+.swift
//  RecurrenceRulePicker
//
//  Created by Norikazu Muramoto on 2024/09/24.
//

import Foundation

extension Locale.Weekday {
    
    public var localizedString: String {
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier ?? "en"
        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) else {
            fatalError()
        }
        return NSLocalizedString(self.localizedStringKey, tableName: nil, bundle: bundle, value: self.localizedStringKey, comment: self.localizedStringKey)
    }
    
    var localizedStringKey: String {
        self.rawValue
    }
}
