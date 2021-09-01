//
//  DayGrid.swift
//  DayGrid
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct DayGrid: View {

    @Binding var selections: Set<Int>

    var spacing: CGFloat = -0.5

    init(_ selections: Binding<Set<Int>>) {
        self._selections = selections
    }

    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing),
            GridItem(.flexible(), spacing: spacing)
        ], spacing: 0) {
            ForEach((1..<32), id: \.self) { day in
                Button {
                    if selections.contains(day) {
                        selections.remove(day)
                    } else {
                        selections.insert(day)
                    }
                } label: {

                    Rectangle()
                        .fill(selections.contains(day) ? Color.accentColor : Color(.tertiarySystemBackground))
                        .overlay(
                            Text("\(day)")
                        )
                        .border(Color(.opaqueSeparator), width: 0.5)
                        .frame(height: 48)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(selections.contains(day) ? .white : Color(.label))
            }
        }
    }
}

struct DayGrid_Previews: PreviewProvider {
    static var previews: some View {
        DayGrid(.constant([]))
    }
}
