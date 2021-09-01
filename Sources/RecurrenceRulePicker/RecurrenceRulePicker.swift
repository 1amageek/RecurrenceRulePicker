//
//  RecurrenceRulePicker.swift
//  RecurrenceRulePicker
//
//  Created by nori on 2021/08/31.
//

import SwiftUI

enum DisplayMode {
    case daily
    case week
    case month
    case year
}

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
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case day
    case weekday
    case weekend

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
}

public struct RecurrenceRulePicker: View {

    @Binding public var recurrenceRule: RecurrenceRule

    public init(_ recurrenceRule: Binding<RecurrenceRule>) {
        self._recurrenceRule = recurrenceRule
    }

    @State private var selection: Selection?

    @State private var daysOfTheWeekToggle: Bool = false

    @State private var weekNumber: Int = 0

    @State private var daysOfTheWeekSelection: [Int]?

    @State private var daySelections: Set<Int> = []

    @State private var weekdaySelections: Set<RecurrenceRule.Weekday> = []

    @State private var monthSelections: Set<RecurrenceRule.Month> = []


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
                        Text(LocalizedStringKey(recurrenceRule.frequency.rawValue), bundle: .module)
                            .foregroundColor(.secondary)
                    }

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
                        Text(LocalizedStringKey("\(recurrenceRule.interval) \(recurrenceRule.frequency.text)"), bundle: .module)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                if case .interval = selection {
                    Picker(selection: $recurrenceRule.interval) {
                        ForEach(1..<1000) { interval in
                            Text("\(interval)")
                                .tag(interval)
                        }
                    } label: {
                        Text("Every", bundle: .module)
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }

            switch recurrenceRule.frequency {
                case .daily: EmptyView()
                case .weekly: WeeklyView(weekdaySelections: $weekdaySelections)
                case .monthly: MonthlyView(daySelections: $daySelections, daysOfTheWeekSelection: $daysOfTheWeekSelection)
                case .yearly: YearlyView(monthSelections: $monthSelections, daysOfTheWeekSelection: $daysOfTheWeekSelection)
            }

        }
        .listStyle(GroupedListStyle())
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

        @State var recurrenceRule: RecurrenceRule = RecurrenceRule(frequency: .weekly, interval: 1, firstDayOfTheWeek: 0, daysOfTheWeek: nil, daysOfTheMonth: nil, daysOfTheYear: nil, monthsOfTheYear: nil)

        var body: some View {
            RecurrenceRulePicker($recurrenceRule)
        }
    }

    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
