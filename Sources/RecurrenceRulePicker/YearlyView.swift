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

    @Binding var monthsOfTheYear: Set<RecurrenceRule.Month>

    @Binding var weekNumber: WeekNumberIndex

    @Binding var weekday: WeekdayIndex

    var body: some View {

        Section {
            MonthGrid($monthsOfTheYear)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }

        Section {
            Toggle(isOn: $daysOfTheWeekToggle) {
                Text("Days of Week", bundle: .module)
            }

            if daysOfTheWeekToggle {
                MultiPicker(.init(WeekNumberIndex.allCases, selection: $weekNumber, content: { weekNumber in
                    Text(LocalizedStringKey(weekNumber.text), bundle: .module)
                }), .init(WeekdayIndex.allCases, selection: $weekday, content: { weekday in
                    Text(LocalizedStringKey(weekday.text), bundle: .module)
                }))
                    .listRowInsets(EdgeInsets())
            }
        }
    }
}

struct YearlyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                YearlyView(monthsOfTheYear: .constant([]), weekNumber: .constant(.first), weekday: .constant(.day))
            }
            .listStyle(GroupedListStyle())
        }
    }
}
