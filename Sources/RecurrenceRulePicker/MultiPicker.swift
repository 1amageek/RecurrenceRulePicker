//
//  MultiPicker.swift
//  MultiPicker
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct PickerComponent<Data, SelectionValue, Content> where Data: RandomAccessCollection, SelectionValue: Hashable, Content: View, Data.Element == SelectionValue {

    var data: Data

    var selection: Binding<SelectionValue>

    var content: (Data.Element) -> Content

    init(_ data: Data, selection: Binding<SelectionValue>, content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.selection = selection
        self.content = content
    }
}

struct MultiPicker<D0, D1, S0, S1, C0, C1>: UIViewRepresentable where D0: RandomAccessCollection, D1: RandomAccessCollection, S0: Hashable, S1: Hashable, C0: View, C1: View, D0.Element == S0, D1.Element == S1 {

    typealias UIViewType = UIPickerView

    var c0: PickerComponent<D0, S0, C0>

    var c1: PickerComponent<D1, S1, C1>

    init(_ c0: PickerComponent<D0, S0, C0>, _ c1: PickerComponent<D1, S1, C1>) {
        self.c0 = c0
        self.c1 = c1
    }

    func makeUIView(context: Context) -> UIPickerView {
        let pickerView: UIPickerView = UIPickerView(frame: .zero)
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        pickerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        pickerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return pickerView
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        self.c0.selection.wrappedValue = Array(self.c0.data)[uiView.selectedRow(inComponent: 0)]
        self.c1.selection.wrappedValue = Array(self.c1.data)[uiView.selectedRow(inComponent: 1)]
    }

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

        var parent: MultiPicker

        init(parent: MultiPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
                case 0: return parent.c0.data.count
                case 1: return parent.c1.data.count
                default: fatalError()
            }
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            switch component {
                case 0:
                    let data = Array(parent.c0.data)[row]
                    let content = parent.c0.content(data)
                    let viewController = UIHostingController(rootView: content)
                    return viewController.view
                case 1:
                    let data = Array(parent.c1.data)[row]
                    let content = parent.c1.content(data)
                    let viewController = UIHostingController(rootView: content)
                    return viewController.view
                default: fatalError()
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
                case 0: parent.c0.selection.wrappedValue = Array(parent.c0.data)[row]
                case 1: parent.c1.selection.wrappedValue = Array(parent.c1.data)[row]
                default: fatalError()
            }
        }
    }
}

struct MultiPicker_Previews: PreviewProvider {

    struct ContentView: View {

        @State var selection0: String = "a"

        @State var selection1: Int = 1

        var body: some View {
            VStack {

                MultiPicker(.init(["a"], selection: .constant(""), content: { value in
                    Text(value)
                }), .init((0..<100), selection: $selection1, content: { value in
                    Text("\(value)")
                }))

            }
        }

    }

    static var previews: some View {
        ContentView()
    }
}
