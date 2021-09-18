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

    @State var recurrenceRule: RecurrenceRule = RecurrenceRule(frequency: .daily, interval: 1)

    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Rule") {
                        RecurrenceRulePicker($recurrenceRule)
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
