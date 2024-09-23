//
//  RecurrenceRulePicker.swift
//
//
//  Created by nori on 2022/01/29.
//

import Foundation
import SwiftUI

extension Calendar.RecurrenceRule {
    
    public static func daily() -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601), frequency: .daily)
    }
    
    public static func weekdays() -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .weekly,
                                interval: 1,
                                weekdays: [
                                    .every(.monday),
                                    .every(.tuesday),
                                    .every(.wednesday),
                                    .every(.thursday),
                                    .every(.friday)
                                ])
    }
    
    public static func weekends() -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .weekly,
                                interval: 1,
                                weekdays: [
                                    .every(.thursday),
                                    .every(.sunday)
                                ])
    }
    
    public static func weekly(weekdays: [Weekday]) -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .weekly,
                                interval: 1,
                                weekdays: weekdays)
    }
    
    public static func biweekly(weekdays: [Weekday]) -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .weekly,
                                interval: 2,
                                weekdays: weekdays)
    }
    
    public static func monthly(weekdays: [Weekday] = [], daysOfTheMonth: [Int] = []) -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .monthly,
                                interval: 1,
                                daysOfTheMonth: daysOfTheMonth,
                                weekdays: weekdays)
    }
    
    public static func every3Months(weekdays: [Weekday] = [], daysOfTheMonth: [Int] = []) -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .monthly,
                                interval: 3,
                                daysOfTheMonth: daysOfTheMonth,
                                weekdays: weekdays)
    }
    
    public static func every6Months(weekdays: [Weekday] = [], daysOfTheMonth: [Int] = []) -> Calendar.RecurrenceRule {
        Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601),
                                frequency: .monthly,
                                interval: 6,
                                daysOfTheMonth: daysOfTheMonth,
                                weekdays: weekdays)
    }
}

public struct RecurrenceRulePicker: View {
    
    public enum RepeatType: Hashable {
        
        public static var types: [RecurrenceRulePicker.RepeatType] {
            [
                .never,
                .daily,
                .weekdays,
                .weekends,
                .weekly,
                .biweekly,
                .monthly,
                .every3Months,
                .every6Months
            ]
        }
        
        case never
        case daily
        case weekdays
        case weekends
        case weekly
        case biweekly
        case monthly
        case every3Months
        case every6Months
        case custom(Calendar.RecurrenceRule)
        
        public init(recurrenceRule: Calendar.RecurrenceRule?, occurrenceDate: Date) {
            if let recurrenceRule = recurrenceRule {
                for type in [
                    RepeatType.daily,
                    RepeatType.weekdays,
                    RepeatType.weekends,
                    RepeatType.weekly,
                    RepeatType.biweekly,
                    RepeatType.monthly,
                    RepeatType.every3Months,
                    RepeatType.every6Months
                ] {
                    if type.rule(occurrenceDate) == recurrenceRule {
                        self = type
                        return
                    }
                }
                self = .custom(recurrenceRule)
            } else {
                self = .never
            }
        }
        
        public var localizedString: String {
            let languageCode = Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier ?? "en"
            guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) else {
                fatalError()
            }
            return NSLocalizedString(self.localizedStringKey, tableName: nil, bundle: bundle, value: self.localizedStringKey, comment: self.localizedStringKey)
        }
        
        var localizedStringKey: String {
            switch self {
            case .never: return "repeat.never"
            case .daily: return "repeat.daily"
            case .weekdays: return "repeat.weekdays"
            case .weekends: return "repeat.weekends"
            case .weekly: return "repeat.weekly"
            case .biweekly: return "repeat.biweekly"
            case .monthly: return "repeat.monthly"
            case .every3Months: return "repeat.every3Months"
            case .every6Months: return "repeat.every6Months"
            case .custom(_): return "repeat.custom"
            }
        }
        
        public func rule(_ occurrenceDate: Date) -> Calendar.RecurrenceRule? {
            switch self {
            case .never: return nil
            case .daily: return Calendar.RecurrenceRule.daily()
            case .weekdays: return Calendar.RecurrenceRule.weekdays()
            case .weekends: return Calendar.RecurrenceRule.weekends()
            case .weekly:
                let calendar = Calendar(identifier: .iso8601)
                let weekday = calendar.recurrenceRuleWeekday(for: occurrenceDate)
                return Calendar.RecurrenceRule.weekly(weekdays: [weekday])
            case .biweekly:
                let calendar = Calendar(identifier: .iso8601)
                let weekday = calendar.recurrenceRuleWeekday(for: occurrenceDate)
                return Calendar.RecurrenceRule.biweekly(weekdays: [weekday])
            case .monthly:
                let calendar = Calendar(identifier: .iso8601)
                let day = calendar.component(.day, from: occurrenceDate)
                return Calendar.RecurrenceRule.monthly(daysOfTheMonth: [day])
            case .every3Months:
                let calendar = Calendar(identifier: .iso8601)
                let day = calendar.component(.day, from: occurrenceDate)
                return Calendar.RecurrenceRule.every3Months(daysOfTheMonth: [day])
            case .every6Months:
                let calendar = Calendar(identifier: .iso8601)
                let day = calendar.component(.day, from: occurrenceDate)
                return Calendar.RecurrenceRule.every6Months(daysOfTheMonth: [day])
            case .custom(let rule): return rule
            }
        }
    }
    
    @Binding var recurrenceRule: Calendar.RecurrenceRule?
    
    @State var repeatType: RepeatType
    
    private var occurrenceDate: Date
    
    public init(_ recurrenceRule: Binding<Calendar.RecurrenceRule?>, occurrenceDate: Date = Date()) {
        self._recurrenceRule = recurrenceRule
        self._repeatType = State(initialValue: RepeatType(recurrenceRule: recurrenceRule.wrappedValue, occurrenceDate: occurrenceDate))
        self.occurrenceDate = occurrenceDate
    }
    
    public init(_ recurrenceRule: Binding<Calendar.RecurrenceRule>, occurrenceDate: Date = Date()) {
        self._recurrenceRule = Binding(recurrenceRule)
        self._repeatType = State(initialValue: RepeatType(recurrenceRule: recurrenceRule.wrappedValue, occurrenceDate: occurrenceDate))
        self.occurrenceDate = occurrenceDate
    }
    
    var recurrenceRuleBinding: Binding<Calendar.RecurrenceRule> {
        Binding {
            self.repeatType.rule(occurrenceDate) ?? .daily()
        } set: { transaction in
            self.repeatType = RepeatType(recurrenceRule: transaction, occurrenceDate: occurrenceDate)
        }
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(RepeatType.types, id: \.self) { type in
                    Button {
                        self.repeatType = type
                    } label: {
                        HStack {
                            Text(type.localizedString)
                            Spacer()
                            if repeatType == type {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(.tintColor))
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section {
                NavigationLink {
                    RecurrenceRuleCustomizer(recurrenceRuleBinding)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarTitle(Text("repeat.custom", bundle: .module))
                } label: {
                    HStack {
                        Text("repeat.custom", bundle: .module)
                        Spacer()
                        switch repeatType {
                        case .custom(_):
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(.tintColor))
                        default: EmptyView()
                        }
                    }
                    .contentShape(Rectangle())
                }
            } footer: {
                switch repeatType {
                case .custom(let rule):
                    let frequency = Text(rule.frequency.localizedString)
                    let key = LocalizedStringKey("Event weil occur every \("\(rule.interval)") \(frequency)s")
                    Text(key, bundle: .module)
                default: EmptyView()
                }
            }
            
        }
        .onChange(of: repeatType) { _, newValue in
            self.recurrenceRule = newValue.rule(occurrenceDate)
        }
    }
}


struct RecurrenceRulePicker_Previews: PreviewProvider {
    
    struct ContentView: View {
        
        @State var recurrenceRule: Calendar.RecurrenceRule? = Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601), frequency: .daily, interval: 1)
        
        var body: some View {
            RecurrenceRulePicker($recurrenceRule)
        }
    }
    
    static var previews: some View {
        Group {
            ForEach(["en_US", "ja_JP"], id: \.self) { id in
                NavigationView {
                    ContentView()
                        .navigationViewStyle(.columns)
                }
                .environment(\.locale, .init(identifier: id))
            }
        }
    }
}

extension Calendar {
    
    func recurrenceRuleWeekday(for date: Date) -> RecurrenceRule.Weekday {
        let weekdayComponent = component(.weekday, from: date)
        let localeWeekday: Locale.Weekday
        
        switch weekdayComponent {
        case 1: localeWeekday = .sunday
        case 2: localeWeekday = .monday
        case 3: localeWeekday = .tuesday
        case 4: localeWeekday = .wednesday
        case 5: localeWeekday = .thursday
        case 6: localeWeekday = .friday
        case 7: localeWeekday = .saturday
        default:
            fatalError("Invalid weekday component")
        }
        
        return RecurrenceRule.Weekday.every(localeWeekday)
    }
}

extension Calendar.RecurrenceRule.End: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

extension Calendar.RecurrenceRule.Weekday: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .every(let weekday):
            hasher.combine(0)
            hasher.combine(weekday)
        case .nth(let n, let weekday):
            hasher.combine(1)
            hasher.combine(n)
            hasher.combine(weekday)
        @unknown default:
            fatalError()
        }
    }
}

extension Calendar.RecurrenceRule.Month: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(isLeap)
    }
}

extension Calendar.RecurrenceRule: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(calendar)
        hasher.combine(matchingPolicy)
        hasher.combine(repeatedTimePolicy)
        hasher.combine(frequency)
        hasher.combine(interval)
        hasher.combine(end)
        hasher.combine(seconds)
        hasher.combine(minutes)
        hasher.combine(hours)
        hasher.combine(weekdays)
        hasher.combine(daysOfTheMonth)
        hasher.combine(daysOfTheYear)
        hasher.combine(months)
        hasher.combine(weeks)
        hasher.combine(setPositions)
    }
}
