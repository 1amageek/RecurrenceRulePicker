//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2021/09/18.
//

import SwiftUI
import RecurrenceRule
import RecurrenceRulePicker

struct ContentView: View {

    @State var recurrenceRule: RecurrenceRule? = RecurrenceRule(frequency: .daily, interval: 1)
    
    @Environment(\.locale) var locale: Locale
 
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Rule") {
                        RecurrenceRulePicker($recurrenceRule)
//                            .environment(\.locale, Locale(identifier: "ja"))
                            .onAppear {
                                print(locale.languageCode)
                                print(locale)
                            }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(["en_US", "ja_JP"], id: \.self) { id in
                ContentView()
                    .environment(\.locale, .init(identifier: id))
            }
        }
    }
}
