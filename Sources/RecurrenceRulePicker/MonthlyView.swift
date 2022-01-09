//
//  MonthlyView.swift
//  MonthlyView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI
@_exported import PickerGroup

struct MonthlyView: View {

    enum Mode: CaseIterable {
        case day
        case weekday
    }

    @State var selection: Mode = .day

    @Binding var daysOfTheMonth: Set<Int>

    @Binding var weekNumber: WeekNumberIndex

    @Binding var weekday: WeekdayIndex

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
                DayGrid($daysOfTheMonth)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)

            case .weekday:
                PickerGroup(content: {
                    PickerComponent(selection: $weekNumber) {
                        ForEach(WeekNumberIndex.allCases, id: \.self) { weekNumber in
                            Text(LocalizedStringKey(weekNumber.text), bundle: .module)
                        }
                    }
                    PickerComponent(selection: $weekday) {
                        ForEach(WeekdayIndex.allCases, id: \.self) { weekday in
                            Text(LocalizedStringKey(weekday.text), bundle: .module)
                        }
                    }
                }, label: {
                    EmptyView()
                })
                    .listRowInsets(EdgeInsets())
        }
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                MonthlyView(daysOfTheMonth: .constant([]), weekNumber: .constant(.first), weekday: .constant(.day))
            }
            .listStyle(GroupedListStyle())
        }
    }
}
