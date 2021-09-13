//
//  RecurrenceEndPicker.swift
//  RecurrenceEndPicker
//
//  Created by nori on 2021/09/14.
//

import SwiftUI
import RecurrenceRule

struct RecurrenceEndPicker: View {

    @Binding var end: RecurrenceRule.End?

    var onDateOpacity: Bool {
        if case .endDate(_) = end {
            return true
        }
        return false
    }

    var body: some View {
        List {
            Section {
                Button {
                    end = nil
                } label: {
                    HStack {
                        Text(LocalizedStringKey("Never"), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(end == nil ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Button {
                    end = nil
                } label: {
                    HStack {
                        Text(LocalizedStringKey("On Date"), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(onDateOpacity ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(LocalizedStringKey("End"))
    }
}
struct RecurrenceEndPicker_Previews: PreviewProvider {
    static var previews: some View {
        RecurrenceEndPicker(end: .constant(nil))
    }
}
