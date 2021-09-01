//
//  MultiPicker.swift
//  MultiPicker
//
//  Created by nori on 2021/09/01.
//

import SwiftUI

struct MultiPicker<D0, D1, Content>: UIViewRepresentable where D0 : RandomAccessCollection, D1 : RandomAccessCollection, Content: View {

    typealias UIViewType = UIPickerView

    @Binding var selection: [Int]?

    var content: (Int, Int) -> Content

    var data: (D0, D1)

    init(_ d0: D0, _ d1: D1, selection: Binding<[Int]?>, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.data = (d0, d1)
        self._selection = selection
        self.content = content
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
        self.selection = (0..<2).map { index in
            return uiView.selectedRow(inComponent: index)
        }
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
                case 0: return parent.data.0.count
                case 1: return parent.data.1.count
                default: fatalError()
            }
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let content = self.parent.content
            let view = content(component, row)
            let viewController = UIHostingController(rootView: view)
            return viewController.view
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selection = (0..<2).map { index in
                return pickerView.selectedRow(inComponent: index)
            }
        }
    }

}

struct MultiPicker_Previews: PreviewProvider {

    struct ContentView: View {

        @State var selection: [Int]?

        var body: some View {
            VStack {
                if let selection = selection {
                    Text("\(selection[0])")
                    Text("\(selection[1])")
                }

                MultiPicker(["ww", "w", "aa"], ["aaa"], selection: $selection) { component, row in
                    Text("\(component), \(row)")
                }
            }
        }

    }

    static var previews: some View {
        ContentView()
    }
}
