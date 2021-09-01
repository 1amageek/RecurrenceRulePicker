//
//  WeeklyView.swift
//  WeeklyView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct WeeklyView: View {

    @Binding var weekdaySelections: Set<RecurrenceRule.Weekday>

    var body: some View {
        Section {
            ForEach(RecurrenceRule.Weekday.allCases, id: \.self) { weekday in
                Button {
                    if weekdaySelections.contains(weekday) {
                        weekdaySelections.remove(weekday)
                    } else {
                        weekdaySelections.insert(weekday)
                    }
                } label: {
                    HStack {
                        Text(LocalizedStringKey(weekday.text), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(weekdaySelections.contains(weekday) ? 1 : 0)
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
                WeeklyView(weekdaySelections: .constant([]))
            }
            .listStyle(GroupedListStyle())
        }
    }
}
