//
//  RecurrenceEndPicker.swift
//  RecurrenceEndPicker
//
//  Created by nori on 2021/09/14.
//

import SwiftUI

@MainActor
struct RecurrenceEndPicker: View {
    
    @Binding var end: Calendar.RecurrenceRule.End
    
    @State var selection: Selection = .never
    
    @State var date: Date = Date()
    
    init(end: Binding<Calendar.RecurrenceRule.End>) {
        self._end = end
    }
    
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
        .onChange(of: selection) { _, newValue in
            switch selection {
            case .never:
                self.end = .never
            case .onDate:
                self.end = .afterDate(self.date)
            }
        }
        .onChange(of: date) { _, newValue in
            switch selection {
            case .never:
                self.end = .never
            case .onDate:
                self.end = .afterDate(self.date)
            }
        }
        .onDisappear {
            switch selection {
            case .never:
                self.end = .never
            case .onDate:
                self.end = .afterDate(self.date)
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
        Group {
            ForEach(["en_US", "ja_JP"], id: \.self) { id in
                NavigationView {
                    RecurrenceEndPicker(end: .constant(.never))
                        .navigationViewStyle(.columns)
                }
                .environment(\.locale, .init(identifier: id))
            }
        }
    }
}
