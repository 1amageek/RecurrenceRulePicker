//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct YearlyView: View {
    enum Mode: CaseIterable {
        case day
        case weekday
    }

    @State private var daysOfTheWeekToggle: Bool = false

    @Binding var monthSelections: Set<RecurrenceRule.Month>

    @Binding var daysOfTheWeekSelection: [Int]?

    var body: some View {

        Section {
            MonthGrid($monthSelections)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }

        Toggle(isOn: $daysOfTheWeekToggle) {
            Text("Days of Week", bundle: .module)
        }

        if daysOfTheWeekToggle {
            MultiPicker(WeekNumberIndex.allCases, WeekdayIndex.allCases, selection: $daysOfTheWeekSelection) { component, row -> Text in
                switch component {
                    case 0:
                        let weekNumber = WeekNumberIndex.allCases[row]
                        return Text(LocalizedStringKey(weekNumber.text), bundle: .module)
                    case 1:
                        let weekday = WeekdayIndex.allCases[row]
                        return Text(LocalizedStringKey(weekday.text), bundle: .module)
                    default: fatalError()
                }
            }
        }
    }
}

struct YearlyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                YearlyView(monthSelections: .constant([]), daysOfTheWeekSelection: .constant(nil))
            }
            .listStyle(GroupedListStyle())
        }
    }
}
