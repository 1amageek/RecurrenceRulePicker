//
//  MonthGrid.swift
//  MonthGrid
//
//  Created by nori on 2021/08/31.
//

import SwiftUI
@_exported import RecurrenceRule

struct MonthGrid: View {

    @Binding var selections: Set<RecurrenceRule.Month>

    var spacing: CGFloat = -0.5

    init(_ selections: Binding<Set<RecurrenceRule.Month>>) {
        self._selections = selections
    }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ], spacing: spacing) {
            ForEach(RecurrenceRule.Month.allCases, id: \.self) { month in
                Button {
                    if selections.contains(month) {
                        selections.remove(month)
                    } else {
                        selections.insert(month)
                    }
                } label: {
                    Rectangle()
                        .fill(selections.contains(month) ? Color.accentColor : Color(.tertiarySystemBackground))
                        .overlay(
                            Text(LocalizedStringKey(month.text), bundle: .module)
                        )
                        .border(Color(.separator), width: 0.5)
                        .frame(height: 48)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(selections.contains(month) ? .white : Color(.label))
            }
        }
    }
}

struct MonthGrid_Previews: PreviewProvider {
    static var previews: some View {
        MonthGrid(.constant([]))
            .tint(Color.red)
    }
}
