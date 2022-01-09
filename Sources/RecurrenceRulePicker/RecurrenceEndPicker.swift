//
//  RecurrenceEndPicker.swift
//  RecurrenceEndPicker
//
//  Created by nori on 2021/09/14.
//

import SwiftUI
@_exported import RecurrenceRule

struct RecurrenceEndPicker: View {

    @Binding var end: RecurrenceRule.End?

    @State var selection: Selection = .never

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
        .navigationTitle(LocalizedStringKey("End"))
        .onAppear {
            if let end = end {
                switch end {
                    case .endDate(let date): self.date = date
                    default: break
                }
            } else {
                self.selection = .never
            }
        }
        .onChange(of: selection, perform: { newValue in
            switch selection {
                case .never:
                    self.end = nil
                case .onDate:
                    self.end = .endDate(self.date)
            }
        })
        .onChange(of: date, perform: { newValue in
            switch selection {
                case .never:
                    self.end = nil
                case .onDate:
                    self.end = .endDate(self.date)
            }
        })
        .onDisappear {
            switch selection {
                case .never:
                    self.end = nil
                case .onDate:
                    self.end = .endDate(self.date)
            }
        }
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
