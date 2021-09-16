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

    @State var selection: Selection = .onDate

    @State var date: Date = Date()

    var body: some View {
        List {
            Section {
                Button {
                    withAnimation {
                        self.selection = .never
                    }
                } label: {
                    HStack {
                        Text(LocalizedStringKey("Never"), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(selection == .never ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Button {
                    withAnimation {
                        self.selection = .onDate
                    }
                } label: {
                    HStack {
                        Text(LocalizedStringKey("On Date"), bundle: .module)
                        Spacer()
                        Image(systemName: "checkmark")
                            .opacity(selection == .onDate ? 1 : 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                switch selection {
                    case .never: EmptyView()
                    case .onDate:
                        DatePicker(LocalizedStringKey("End date"), selection: $date, in: Date()..., displayedComponents: [.date])
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle(LocalizedStringKey("End"))
    }
}

extension RecurrenceEndPicker {
    enum Selection {
        case never
        case onDate
    }
}

struct RecurrenceEndPicker_Previews: PreviewProvider {
    static var previews: some View {
        RecurrenceEndPicker(end: .constant(nil))
    }
}
