//
//  WeeklyView.swift
//  WeeklyView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI
@_exported import RecurrenceRule

struct WeeklyView: View {

    @Binding var daysOfTheWeek: Set<RecurrenceRule.Weekday>

    var body: some View {
        Section {
            ForEach(RecurrenceRule.Weekday.allCases, id: \.self) { weekday in
                Button {
                    if daysOfTheWeek.contains(weekday) {
                        daysOfTheWeek.remove(weekday)
                    } else {
                        daysOfTheWeek.insert(weekday)
                    }
                } label: {
                    HStack {
                        Text(LocalizedStringKey(weekday.text), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(daysOfTheWeek.contains(weekday) ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                WeeklyView(daysOfTheWeek: .constant([]))
            }
#if os(iOS)
            .listStyle(GroupedListStyle())
#endif
        }
    }
}
