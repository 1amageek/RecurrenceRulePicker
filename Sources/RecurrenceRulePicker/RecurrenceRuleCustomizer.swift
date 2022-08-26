//
//  RecurrenceRulePicker.swift
//  RecurrenceRulePicker
//
//  Created by nori on 2021/08/31.
//

import SwiftUI
@_exported import PickerGroup
@_exported import RecurrenceRule

enum WeekNumberIndex: Int, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
    case last = -1
    
    public var localizedString: String {
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).languageCode ?? "en"
        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) else {
            fatalError()
        }
        return NSLocalizedString(self.localizedStringKey, tableName: nil, bundle: bundle, value: self.localizedStringKey, comment: self.localizedStringKey)
    }
    
    var localizedStringKey: String {
        switch self {
            case .first: return "first"
            case .second: return "second"
            case .third: return "third"
            case .fourth: return "fourth"
            case .fifth: return "fifth"
            case .last: return "last"
        }
    }
}

enum WeekdayIndex: Int, CaseIterable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case day = 0
    case weekday = 8
    case weekend = 9

    public var localizedString: String {
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).languageCode ?? "en"
        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"), let bundle = Bundle(path: path) else {
            fatalError()
        }
        return NSLocalizedString(self.localizedStringKey, tableName: nil, bundle: bundle, value: self.localizedStringKey, comment: self.localizedStringKey)
    }
    
    var localizedStringKey: String {
        switch self {
            case .sunday: return "sunday"
            case .monday: return "monday"
            case .tuesday: return "tuesday"
            case .wednesday: return "wednesday"
            case .thursday: return "thursday"
            case .friday: return "friday"
            case .saturday: return "saturday"
            case .day: return "day"
            case .weekday: return "weekday"
            case .weekend: return "weekend day"
        }
    }

    var value: [RecurrenceRule.Weekday] {
        switch self {
            case .sunday: return [.sunday]
            case .monday: return [.monday]
            case .tuesday: return [.tuesday]
            case .wednesday: return [.wednesday]
            case .thursday: return [.thursday]
            case .friday: return [.friday]
            case .saturday: return [.saturday]
            case .day: return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
            case .weekday: return [.monday, .tuesday, .wednesday, .thursday, .friday]
            case .weekend: return [.saturday, .sunday]
        }
    }
}

public struct RecurrenceRuleCustomizer: View {

    @Binding public var recurrenceRule: RecurrenceRule

    @State private var selection: Selection?

    @State private var daysOfTheWeekToggle: Bool = false

    @State private var weekNumber: WeekNumberIndex = .first

    @State private var weekday: WeekdayIndex = .sunday

    @State private var daysOfTheMonth: Set<Int> = []

    @State private var daysOfTheWeek: Set<RecurrenceRule.Weekday> = []

    @State private var monthsOfTheYear: Set<RecurrenceRule.Month> = []

    var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }
    
    public init(_ recurrenceRule: Binding<RecurrenceRule>) {
        self._recurrenceRule = recurrenceRule
        let rule = recurrenceRule.wrappedValue
        let daysOfTheWeek = rule.daysOfTheWeek?.map { $0.dayOfTheWeek } ?? []
        let daysOfTheMonth = rule.daysOfTheMonth ?? []
        let monthsOfTheYear = rule.monthsOfTheYear ?? []
        self._daysOfTheWeek = State(initialValue: Set(daysOfTheWeek))
        self._daysOfTheMonth = State(initialValue: Set(daysOfTheMonth))
        self._monthsOfTheYear = State(initialValue: Set(monthsOfTheYear))
    }

    public var body: some View {
        List {
            Section {
                Button {
                    withAnimation {
                        if selection == .frequency {
                            selection = nil
                        } else {
                            selection = .frequency
                        }
                    }
                } label: {
                    HStack {
                        Text("Frequency", bundle: .module)
                        Spacer()
                        Text(recurrenceRule.frequency.localizedString)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if case .frequency = selection {
                    Picker(selection: $recurrenceRule.frequency) {
                        ForEach(RecurrenceRule.Frequency.allCases, id: \.self) { frequency in
                            Text(LocalizedStringKey(frequency.rawValue), bundle: .module)
                                .tag(frequency)
                        }
                    } label: {
                        Text("Frequency", bundle: .module)
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                let frequency = Text(recurrenceRule.frequency.localizedString)
                Button {
                    withAnimation {
                        if selection == .interval {
                            selection = nil
                        } else {
                            selection = .interval
                        }
                    }
                } label: {
                    HStack {
                        Text("Every", bundle: .module)
                        Spacer()
                        Text("\(recurrenceRule.interval)\(frequency)")
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if case .interval = selection {
                    PickerGroup(content: {
                        PickerComponent(selection: $recurrenceRule.interval) {
                            ForEach(1..<1000) { element in
                                Text("\(element)")
                            }
                        }
                        PickerComponent {
                            frequency
                        }
                    }, label: {
                        EmptyView()
                    })
                    .listRowInsets(EdgeInsets())
                }
            }

            switch recurrenceRule.frequency {
                case .daily: EmptyView()
                case .weekly: WeeklyView(daysOfTheWeek: $daysOfTheWeek)
                case .monthly: MonthlyView(daysOfTheMonth: $daysOfTheMonth, weekNumber: $weekNumber, weekday: $weekday)
                case .yearly: YearlyView(monthsOfTheYear: $monthsOfTheYear, weekNumber: $weekNumber, weekday: $weekday)
            }

            Section {
                NavigationLink {
                    RecurrenceEndPicker(end: $recurrenceRule.recurrenceEnd)
                } label: {
                    HStack {
                        Text("End", bundle: .module)
                        Spacer()
                        if let recurrenceEnd = recurrenceRule.recurrenceEnd {
                            switch recurrenceEnd {
                                case .endDate(let date):
                                    Text(date, formatter: dateFormatter)
                                case .occurrenceCount(let count):
                                    Text(LocalizedStringKey("\(count) count"), bundle: .module)
                            }
                        } else {
                            Text("Never", bundle: .module)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .onChange(of: recurrenceRule.frequency) { frequency in

            recurrenceRule.daysOfTheWeek = nil
            recurrenceRule.daysOfTheMonth = nil
            recurrenceRule.daysOfTheYear = nil
            recurrenceRule.weeksOfTheYear = nil
            recurrenceRule.monthsOfTheYear = nil
            recurrenceRule.firstDayOfTheWeek = 0

            switch frequency {
                case .daily: break
                case .weekly:
                    recurrenceRule.daysOfTheWeek = [.init(dayOfTheWeek: .tuesday, weekNumber: 0)]
                    recurrenceRule.firstDayOfTheWeek = RecurrenceRule.Weekday.monday.rawValue
                case .monthly:
                    let day: Int = Calendar.current.dateComponents(in: .current, from: Date()).day!
                    recurrenceRule.daysOfTheMonth = [day]
                case .yearly:
                    let month: Int = Calendar.current.dateComponents(in: .current, from: Date()).month!
                    recurrenceRule.monthsOfTheYear = [RecurrenceRule.Month(rawValue: month)!]
            }

        }
        .onChange(of: daysOfTheWeek) { newValue in
            recurrenceRule.daysOfTheWeek = newValue.map { RecurrenceRule.DayOfWeek(dayOfTheWeek: $0, weekNumber: 0) }
        }
        .onChange(of: daysOfTheMonth) { newValue in
            recurrenceRule.daysOfTheMonth = Array(newValue)
            recurrenceRule.daysOfTheWeek = nil
        }
        .onChange(of: monthsOfTheYear) { newValue in
            if recurrenceRule.frequency == .yearly {
                recurrenceRule.monthsOfTheYear = Array(newValue)
            }
            recurrenceRule.daysOfTheWeek = nil
        }
        .onChange(of: weekNumber) { newValue in
            recurrenceRule.daysOfTheWeek = weekday.value.map { RecurrenceRule.DayOfWeek(dayOfTheWeek: $0, weekNumber: newValue.rawValue) }
            recurrenceRule.firstDayOfTheWeek = RecurrenceRule.Weekday.monday.rawValue
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = nil
            }
        }
        .onChange(of: weekday) { newValue in
            recurrenceRule.daysOfTheWeek = newValue.value.map { RecurrenceRule.DayOfWeek(dayOfTheWeek: $0, weekNumber: weekNumber.rawValue) }
            recurrenceRule.firstDayOfTheWeek = RecurrenceRule.Weekday.monday.rawValue
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = nil
            }
        }
    }
}

extension RecurrenceRuleCustomizer {

    enum Selection {
        case frequency
        case interval
    }
}

struct RecurrenceRuleCustomizer_Previews: PreviewProvider {

    struct ContentView: View {

        @State var recurrenceRule: RecurrenceRule = RecurrenceRule(frequency: .daily, interval: 1)

        var body: some View {
            RecurrenceRuleCustomizer($recurrenceRule)
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
