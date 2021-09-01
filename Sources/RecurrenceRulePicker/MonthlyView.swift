//
//  MonthlyView.swift
//  MonthlyView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct MonthlyView: View {

    enum Mode: CaseIterable {
        case day
        case weekday
    }

    @State var selection: Mode = .day

    @Binding var daySelections: Set<Int>

    @Binding var daysOfTheWeekSelection: [Int]?

    var body: some View {
        Button {
            selection = .day
        } label: {
            HStack {
                Text("Each", bundle: .module)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(selection == .day ? 1 : 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())

        Button {
            selection = .weekday
        } label: {
            HStack {
                Text("On the...", bundle: .module)
                Spacer()
                Image(systemName: "checkmark")
                    .opacity(selection == .weekday ? 1 : 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())


        switch selection {
            case .day:
                DayGrid($daySelections)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)

            case .weekday:
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
                .listRowInsets(EdgeInsets())

        }
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                MonthlyView(daySelections: .constant([]), daysOfTheWeekSelection: .constant(nil))
            }
            .listStyle(GroupedListStyle())
        }
    }
}
