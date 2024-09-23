//
//  MonthGrid.swift
//  MonthGrid
//
//  Created by nori on 2021/08/31.
//

import SwiftUI

@MainActor
struct MonthGrid: View {
    @Binding var selections: Set<Calendar.RecurrenceRule.Month>
    var spacing: CGFloat = -0.5
    
    init(_ selections: Binding<Set<Calendar.RecurrenceRule.Month>>, spacing: CGFloat = -0.5) {
        self._selections = selections
        self.spacing = spacing
    }
    
    let months: [Calendar.RecurrenceRule.Month] = (1...12).map { Calendar.RecurrenceRule.Month($0) }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ], spacing: spacing) {
            ForEach(months, id: \.self) { month in
                Button {
                    toggleSelection(month)
                } label: {
                    Rectangle()
                        .fill(selections.contains(month) ? Color.accentColor : Color(.tertiarySystemBackground))
                        .overlay(
                            Text(month.index, format: .number)
                        )
                        .border(Color(.separator), width: 0.5)
                        .frame(height: 48)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(selections.contains(month) ? .white : Color(.label))
            }
        }
    }
    
    private func toggleSelection(_ month: Calendar.RecurrenceRule.Month) {
        if selections.contains(month) {
            selections.remove(month)
        } else {
            selections.insert(month)
        }
    }
}

struct MonthGrid_Previews: PreviewProvider {
    static var previews: some View {
        MonthGrid(.constant([]))
            .tint(Color.red)
    }
}
