//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI
@_exported import PickerGroup
@_exported import RecurrenceRule

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
                PickerGroup(content: {
                    PickerComponent(selection: $weekNumber) {
                        ForEach(WeekNumberIndex.allCases, id: \.self) { weekNumber in
                            Text(weekNumber.localizedString)
                        }
                    }
                    PickerComponent(selection: $weekday) {
                        ForEach(WeekdayIndex.allCases, id: \.self) { weekday in
                            Text(weekday.localizedString)
                        }
                    }
                }, label: {
                    EmptyView()
                })
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
#if os(iOS)
            .listStyle(GroupedListStyle())
#endif
        }
    }
}
