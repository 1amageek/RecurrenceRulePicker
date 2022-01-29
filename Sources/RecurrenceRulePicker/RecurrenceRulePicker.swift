//
//  RecurrenceRulePicker.swift
//  
//
//  Created by nori on 2022/01/29.
//

import SwiftUI
import RecurrenceRule

extension RecurrenceRule {

    public static var daily: RecurrenceRule {
        RecurrenceRule(frequency: .daily, interval: 1)
    }

    public static var weekdays: RecurrenceRule {
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

    public static var weekends: RecurrenceRule {
        RecurrenceRule(
            frequency: .weekly,
            interval: 1,
            firstDayOfTheWeek: RecurrenceRule.Weekday.monday.rawValue,
            daysOfTheWeek: [
                DayOfWeek(dayOfTheWeek: .sunday),
                DayOfWeek(dayOfTheWeek: .thursday)
            ])
    }

    public static var weekly: RecurrenceRule {
        RecurrenceRule(frequency: .weekly, interval: 1)
    }

    public static var biweekly: RecurrenceRule {
        RecurrenceRule(frequency: .weekly, interval: 2)
    }

    public static var monthly: RecurrenceRule {
        RecurrenceRule(frequency: .monthly, interval: 1)
    }

    public static var every3Months: RecurrenceRule {
        RecurrenceRule(frequency: .monthly, interval: 3)
    }

    public static var every6Months: RecurrenceRule {
        RecurrenceRule(frequency: .monthly, interval: 6)
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

        public init(recurrenceRule: RecurrenceRule?) {
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
                    if type.rule == recurrenceRule {
                        self = type
                        return
                    }
                }
                self = .custom(recurrenceRule)
            } else {
                self = .never
            }
        }

        public var rawValue: String {
            switch self {
                case .never: return "never"
                case .daily: return "daily"
                case .weekdays: return "weekdays"
                case .weekends: return "weekends"
                case .weekly: return "weekly"
                case .biweekly: return "biweekly"
                case .monthly: return "monthly"
                case .every3Months: return "every3Months"
                case .every6Months: return "every6Months"
                case .custom(_): return "custom"
            }
        }

        public var text: String {
            return NSLocalizedString(self.rawValue, bundle: .module, comment: "Recurrence")
        }

        public var rule: RecurrenceRule? {
            switch self {
                case .never: return nil
                case .daily: return RecurrenceRule.daily
                case .weekdays: return RecurrenceRule.weekdays
                case .weekends: return RecurrenceRule.weekends
                case .weekly: return RecurrenceRule.weekly
                case .biweekly: return RecurrenceRule.biweekly
                case .monthly: return RecurrenceRule.monthly
                case .every3Months: return RecurrenceRule.every3Months
                case .every6Months: return RecurrenceRule.every6Months
                case .custom(let rule): return rule
            }
        }
    }

    @Binding var recurrenceRule: RecurrenceRule?

    @State var repeatType: RepeatType

    public init(recurrenceRule: Binding<RecurrenceRule?>) {
        self._recurrenceRule = recurrenceRule
        self._repeatType = State(initialValue: RepeatType(recurrenceRule: recurrenceRule.wrappedValue))
    }

    var recurrenceRuleBinding: Binding<RecurrenceRule> {
        Binding {
            self.repeatType.rule ?? .daily
        } set: { transaction in
            self.repeatType = RepeatType(recurrenceRule: transaction)
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
                            Text(type.text)
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
                        .navigationBarTitle(Text("custom", bundle: .module))
                } label: {
                    HStack {
                        Text("Custom")
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
                        Text("Event weil occur every ")
                        + Text(rule.interval, format: .number)
                        + Text(" ")
                        + Text(LocalizedStringKey(rule.frequency.text), bundle: .module)
                        + Text("s")
                    default: EmptyView()
                }
            }

        }
        .onChange(of: repeatType) { newValue in
            self.recurrenceRule = newValue.rule
        }
    }
}


struct RecurrenceRulePicker_Previews: PreviewProvider {

    struct ContentView: View {

        @State var recurrenceRule: RecurrenceRule? = RecurrenceRule(frequency: .daily, interval: 1)

        var body: some View {
            RecurrenceRulePicker(recurrenceRule: $recurrenceRule)
        }
    }

    static var previews: some View {
        NavigationView {
            ContentView()
                .navigationViewStyle(.columns)
        }
    }
}
