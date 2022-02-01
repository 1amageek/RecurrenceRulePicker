//
//  RecurrenceRulePicker.swift
//  
//
//  Created by nori on 2022/01/29.
//

import Foundation
import SwiftUI
import RecurrenceRule

extension RecurrenceRule {

    public static func daily() -> RecurrenceRule {
        RecurrenceRule(
            frequency: .daily,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue
        )
    }

    public static func weekdays() -> RecurrenceRule {
        RecurrenceRule(
            frequency: .weekly,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: [
                DayOfWeek(dayOfTheWeek: .monday),
                DayOfWeek(dayOfTheWeek: .tuesday),
                DayOfWeek(dayOfTheWeek: .wednesday),
                DayOfWeek(dayOfTheWeek: .thursday),
                DayOfWeek(dayOfTheWeek: .friday)
            ])
    }

    public static func weekends() -> RecurrenceRule {
        RecurrenceRule(
            frequency: .weekly,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: [
                DayOfWeek(dayOfTheWeek: .sunday),
                DayOfWeek(dayOfTheWeek: .thursday)
            ])
    }

    public static func weekly(daysOfTheWeek: [DayOfWeek]) -> RecurrenceRule {
        RecurrenceRule(
            frequency: .weekly,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: daysOfTheWeek)
    }

    public static func biweekly(daysOfTheWeek: [DayOfWeek]) -> RecurrenceRule {
        RecurrenceRule(
            frequency: .weekly,
            interval: 2,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: daysOfTheWeek)
    }

    public static func monthly(daysOfTheWeek: [DayOfWeek]?, daysOfTheMonth: [Int]?) -> RecurrenceRule {
        RecurrenceRule(
            frequency: .monthly,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: daysOfTheWeek,
            daysOfTheMonth: daysOfTheMonth
        )
    }

    public static func every3Months(daysOfTheWeek: [DayOfWeek]?, daysOfTheMonth: [Int]?) -> RecurrenceRule {
        RecurrenceRule(
            frequency: .monthly,
            interval: 3,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: daysOfTheWeek,
            daysOfTheMonth: daysOfTheMonth
        )
    }

    public static func every6Months(daysOfTheWeek: [DayOfWeek]?, daysOfTheMonth: [Int]?) -> RecurrenceRule {
        RecurrenceRule(
            frequency: .monthly,
            interval: 6,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: daysOfTheWeek,
            daysOfTheMonth: daysOfTheMonth
        )
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
        case custom(RecurrenceRule)

        public init(recurrenceRule: RecurrenceRule?, occurrenceDate: Date) {
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

        public var rawValue: LocalizedStringKey {
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

        public var text: String {
            return NSLocalizedString("\(self.rawValue)", bundle: .module, comment: "Recurrence")
        }

        public func rule(_ occurrenceDate: Date) -> RecurrenceRule? {
            switch self {
                case .never: return nil
                case .daily: return RecurrenceRule.daily()
                case .weekdays: return RecurrenceRule.weekdays()
                case .weekends: return RecurrenceRule.weekends()
                case .weekly:
                    let calendar = Calendar(identifier: .iso8601)
                    let weekday = RecurrenceRule.Weekday(rawValue: calendar.component(.weekday, from: occurrenceDate))!
                    return RecurrenceRule.weekly(daysOfTheWeek: [RecurrenceRule.DayOfWeek(dayOfTheWeek: weekday)])
                case .biweekly:
                    let calendar = Calendar(identifier: .iso8601)
                    let weekday = RecurrenceRule.Weekday(rawValue: calendar.component(.weekday, from: occurrenceDate))!
                    return RecurrenceRule.biweekly(daysOfTheWeek: [RecurrenceRule.DayOfWeek(dayOfTheWeek: weekday)])
                case .monthly:
                    let calendar = Calendar(identifier: .iso8601)
                    let day = calendar.component(.day, from: occurrenceDate)
                    return RecurrenceRule.monthly(daysOfTheWeek: nil, daysOfTheMonth: [day])
                case .every3Months:
                    let calendar = Calendar(identifier: .iso8601)
                    let day = calendar.component(.day, from: occurrenceDate)
                    return RecurrenceRule.every3Months(daysOfTheWeek: nil, daysOfTheMonth: [day])
                case .every6Months:
                    let calendar = Calendar(identifier: .iso8601)
                    let day = calendar.component(.day, from: occurrenceDate)
                    return RecurrenceRule.every6Months(daysOfTheWeek: nil, daysOfTheMonth: [day])
                case .custom(let rule): return rule
            }
        }
    }

    @Binding var recurrenceRule: RecurrenceRule?

    @State var repeatType: RepeatType

    private var occurrenceDate: Date

    public init(_ recurrenceRule: Binding<RecurrenceRule?>, occurrenceDate: Date = Date()) {
        self._recurrenceRule = recurrenceRule
        self._repeatType = State(initialValue: RepeatType(recurrenceRule: recurrenceRule.wrappedValue, occurrenceDate: occurrenceDate))
        self.occurrenceDate = occurrenceDate
    }

    var recurrenceRuleBinding: Binding<RecurrenceRule> {
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
                            Text(type.rawValue, bundle: .module)
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
                        let localizedString = NSLocalizedString("Event weil occur every %d %@s", bundle: .module, comment: "Occur")
                        let footer = String(format: localizedString, rule.interval, rule.frequency.text)
                        Text(footer)
                    default: EmptyView()
                }
            }

        }
        .onChange(of: repeatType) { newValue in
            self.recurrenceRule = newValue.rule(occurrenceDate)
        }
    }
}


struct RecurrenceRulePicker_Previews: PreviewProvider {

    struct ContentView: View {

        @State var recurrenceRule: RecurrenceRule? = RecurrenceRule(frequency: .daily, interval: 1)

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
