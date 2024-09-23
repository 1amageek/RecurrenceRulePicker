//
//  RecurrenceRulePicker.swift
//  RecurrenceRulePicker
//
//  Created by nori on 2021/08/31.
//

import SwiftUI
@_exported import PickerGroup

enum WeekNumberIndex: Int, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
    case last = -1
    
    public var localizedString: String {
        let languageCode = Locale(identifier: Locale.preferredLanguages.first!).language.languageCode?.identifier ?? "en"
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
    
    public init?(weekday: Locale.Weekday) {
        switch weekday {
        case .sunday:
            self = .sunday
        case .monday:
            self = .monday
        case .tuesday:
            self = .tuesday
        case .wednesday:
            self = .wednesday
        case .thursday:
            self = .thursday
        case .friday:
            self = .friday
        case .saturday:
            self = .saturday
        @unknown default:
            return nil
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
        case .sunday: return "sun"
        case .monday: return "mon"
        case .tuesday: return "tue"
        case .wednesday: return "wed"
        case .thursday: return "thu"
        case .friday: return "fri"
        case .saturday: return "sat"
        case .day: return "day"
        case .weekday: return "weekday"
        case .weekend: return "weekend day"
        }
    }
    
    func value(_ index: Int) -> [Calendar.RecurrenceRule.Weekday] {
        switch self {
        case .sunday: return [.nth(index, .sunday)]
        case .monday: return [.nth(index, .monday)]
        case .tuesday: return [.nth(index, .tuesday)]
        case .wednesday: return [.nth(index, .wednesday)]
        case .thursday: return [.nth(index, .thursday)]
        case .friday: return [.nth(index, .friday)]
        case .saturday: return [.nth(index, .saturday)]
        case .day: return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday].map({ .nth(index, $0) })
        case .weekday: return [.monday, .tuesday, .wednesday, .thursday, .friday].map({ .nth(index, $0) })
        case .weekend: return [.saturday, .sunday].map({ .nth(index, $0) })
        }
    }
}

public struct RecurrenceRuleCustomizer: View {
    
    @Binding public var recurrenceRule: Calendar.RecurrenceRule
    
    @State private var selection: Selection?
    
    @State private var daysOfTheWeekToggle: Bool = false
    
    @State private var weekNumber: WeekNumberIndex = .first
    
    @State private var weekday: WeekdayIndex = .sunday
    
    @State private var daysOfTheMonth: Set<Int> = []
    
    @State private var weekdays: Set<Calendar.RecurrenceRule.Weekday> = []
    
    @State private var months: Set<Calendar.RecurrenceRule.Month> = []
    
    var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }
    
    public init(_ recurrenceRule: Binding<Calendar.RecurrenceRule>) {
        self._recurrenceRule = recurrenceRule
        let rule = recurrenceRule.wrappedValue
        let daysOfTheMonth = rule.daysOfTheMonth
        let weekdays = rule.weekdays
        let months = rule.months
        
        if case .nth(let index, let weekday) = rule.weekdays.first {
            self._weekNumber = State(initialValue: WeekNumberIndex(rawValue: index)!)
            self._weekday = State(initialValue: WeekdayIndex(weekday: weekday)!)
        }
        
        self._daysOfTheMonth = State(initialValue: Set(daysOfTheMonth))
        self._weekdays = State(initialValue: Set(weekdays))
        self._months = State(initialValue: Set(months))
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
                        ForEach([
                            Calendar.RecurrenceRule.Frequency.yearly,
                            Calendar.RecurrenceRule.Frequency.monthly,
                            Calendar.RecurrenceRule.Frequency.weekly,
                            Calendar.RecurrenceRule.Frequency.daily
                        ], id: \.self) { frequency in
                            Text(frequency.localizedString)
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
            case .weekly: WeeklyView(weekdays: $weekdays)
            case .monthly: MonthlyView(daysOfTheMonth: $daysOfTheMonth, weekNumber: $weekNumber, weekday: $weekday)
            case .yearly: YearlyView(months: $months, weekNumber: $weekNumber, weekday: $weekday)
            default: EmptyView()
            }
            
            Section {
                NavigationLink {
                    RecurrenceEndPicker(end: $recurrenceRule.end)
                } label: {
                    HStack {
                        Text("End", bundle: .module)
                        Spacer()
                        if recurrenceRule.end == .never {
                            Text("Never", bundle: .module)
                                .foregroundColor(.secondary)
                        } else if let date = recurrenceRule.end.date {
                            Text(date, format: .dateTime.year().month().day())
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .onChange(of: recurrenceRule.frequency) { _, frequency in
            
            recurrenceRule.weekdays = []
            recurrenceRule.months = []
            recurrenceRule.daysOfTheMonth = []
            recurrenceRule.daysOfTheYear = []
            
            switch frequency {
            case .weekly:
                recurrenceRule.weekdays = [.every(.monday)]
            case .monthly:
                let day: Int = Calendar.current.dateComponents(in: .current, from: Date()).day!
                recurrenceRule.daysOfTheMonth = [day]
            case .yearly:
                let month: Int = Calendar.current.dateComponents(in: .current, from: Date()).month!
                recurrenceRule.months = [Calendar.RecurrenceRule.Month(month)]
            default: break
            }
            
        }
        .onChange(of: weekdays) { _, newValue in
            recurrenceRule.weekdays = Array(newValue)
        }
        .onChange(of: daysOfTheMonth) { _, newValue in
            recurrenceRule.daysOfTheMonth = Array(newValue)
            recurrenceRule.weekdays = []
        }
        .onChange(of: months) { _, newValue in
            if recurrenceRule.frequency == .yearly {
                recurrenceRule.months = Array(newValue)
            }
            recurrenceRule.weekdays = []
        }
        .onChange(of: weekNumber) { _, newValue in
            recurrenceRule.weekdays = weekday.value(newValue.rawValue)
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = []
            }
        }
        .onChange(of: weekday) { _, newValue in
            recurrenceRule.weekdays = newValue.value(weekNumber.rawValue)
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = []
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
        
        @State var recurrenceRule: Calendar.RecurrenceRule = Calendar.RecurrenceRule(calendar: Calendar(identifier: .iso8601), frequency: .daily)
        
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
