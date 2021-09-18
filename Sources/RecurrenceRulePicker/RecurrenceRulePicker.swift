//
//  RecurrenceRulePicker.swift
//  RecurrenceRulePicker
//
//  Created by nori on 2021/08/31.
//

import SwiftUI
import PickerGroup
import RecurrenceRule

enum WeekNumberIndex: Int, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
    case last = -1

    var text: String {
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

    var text: String {
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

public struct RecurrenceRulePicker: View {

    @Binding public var recurrenceRule: RecurrenceRule

    public init(_ recurrenceRule: Binding<RecurrenceRule>) {
        self._recurrenceRule = recurrenceRule
    }

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

    public var body: some View {
        List {
            Section {

                Button {
                    DispatchQueue.main.async {
                        withAnimation {
                            if selection == .frequency {
                                selection = nil
                            } else {
                                selection = .frequency
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Frequency", bundle: .module)
                        Spacer()
                        Text(LocalizedStringKey(recurrenceRule.frequency.rawValue), bundle: .module)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

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

                Button {
                    DispatchQueue.main.async {
                        withAnimation {
                            if selection == .interval {
                                selection = nil
                            } else {
                                selection = .interval
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Every", bundle: .module)
                        Spacer()
                        Text(LocalizedStringKey("\(recurrenceRule.interval)\(recurrenceRule.frequency.text)"), bundle: .module)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                if case .interval = selection {

                    PickerGroup(content: {
                        PickerComponent(selection: $recurrenceRule.interval) {
                            ForEach(1..<1000) { element in
                                Text("\(element)")
                            }
                        }
                        PickerComponent {
                            Group {
                                if recurrenceRule.interval < 2 {
                                    Text(LocalizedStringKey("\(recurrenceRule.frequency.text)"), bundle: .module)
                                } else {
                                    Text(LocalizedStringKey("\(recurrenceRule.frequency.text)s"), bundle: .module)
                                }
                            }
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
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear {
            let rule = $recurrenceRule.wrappedValue
            let daysOfTheWeek = rule.daysOfTheWeek?.map { $0.dayOfTheWeek } ?? []
            let daysOfTheMonth = rule.daysOfTheMonth ?? []
            let monthsOfTheYear = rule.monthsOfTheYear ?? []
            self.daysOfTheWeek = Set(daysOfTheWeek)
            self.daysOfTheMonth = Set(daysOfTheMonth)
            self.monthsOfTheYear = Set(monthsOfTheYear)
        }
        .onChange(of: recurrenceRule.frequency) { newValue in
            recurrenceRule.daysOfTheWeek = nil
            recurrenceRule.daysOfTheMonth = nil
            recurrenceRule.daysOfTheYear = nil
            recurrenceRule.weeksOfTheYear = nil
            recurrenceRule.monthsOfTheYear = nil
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
        }
        .onChange(of: weekNumber) { newValue in
            recurrenceRule.daysOfTheWeek = weekday.value.map { RecurrenceRule.DayOfWeek(dayOfTheWeek: $0, weekNumber: newValue.rawValue) }
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = nil
            }
        }
        .onChange(of: weekday) { newValue in
            recurrenceRule.daysOfTheWeek = newValue.value.map { RecurrenceRule.DayOfWeek(dayOfTheWeek: $0, weekNumber: weekNumber.rawValue) }
            if recurrenceRule.frequency == .monthly {
                recurrenceRule.daysOfTheMonth = nil
            }
        }
    }
}

extension RecurrenceRulePicker {

    enum Selection {
        case frequency
        case interval
    }
}

struct RecurrenceRulePicker_Previews: PreviewProvider {

    struct ContentView: View {

        @State var recurrenceRule: RecurrenceRule = RecurrenceRule(frequency: .daily, interval: 1)

        var body: some View {
            RecurrenceRulePicker($recurrenceRule)
        }
    }

    static var previews: some View {
        NavigationView {
            ContentView()
                .navigationViewStyle(.columns)
        }
    }
}
