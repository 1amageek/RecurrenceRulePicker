//
//  WeeklyView.swift
//  WeeklyView
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

@MainActor
struct WeeklyView: View {
    
    @Binding var weekdays: Set<Calendar.RecurrenceRule.Weekday>
    
    init(weekdays: Binding<Set<Calendar.RecurrenceRule.Weekday>>) {
        self._weekdays = weekdays
    }
    
    let weekdaySymbols: [Locale.Weekday] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

    var body: some View {
        Section {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Button {
                    toggleWeekday(.every(weekday))
                } label: {
                    HStack {                        
                        Text(weekday.localizedString)
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .opacity(weekdays.contains(.every(weekday)) ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func toggleWeekday(_ weekday: Calendar.RecurrenceRule.Weekday) {
        if weekdays.contains(weekday) {
            weekdays.remove(weekday)
        } else {
            weekdays.insert(weekday)
        }
    }
}

struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                WeeklyView(weekdays: .constant([]))
            }
#if os(iOS)
            .listStyle(GroupedListStyle())
#endif
        }
    }
}
