//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nori on 2021/09/14.
//

import SwiftUI
import Calendar

struct OnDate: View {

    @Binding var selectedDate: Date?

    var date: Date

    init(_ selectedDate: Binding<Date?>, date: Date = Date()) {
        self._selectedDate = selectedDate
        self.date = date
    }

    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
    }

    func forMonth(month: Date, size: CGSize) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(DateRange(month.firstDayOfTheWeek, range: 0..<42, component: .day)) { date in
                Text("\(date.day)")
                    .font(.system(size: 22))
                    .foregroundColor(date < self.date ? .secondary : nil)
                    .opacity(date.month == month.month ? 1 : 0)
                    .frame(height: size.height / 6)
                    .contentShape(Rectangle())
                    .background {
                        if self.selectedDate == date {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 32, height: 32)
                        } else {
                            EmptyView()
                        }
                    }
                    .onTapGesture {
                        self.selectedDate = date
                    }
            }
        }
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(Foundation.Calendar(identifier: .gregorian).shortWeekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(.systemGray))
                    }
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(DateRange(date, range: 0..<2, component: .month)) { month in
                            forMonth(month: month, size: proxy.size)
                            .frame(width: proxy.size.width)
                        }
                    }
                }
            }
        }
    }
}

struct OnDate_Previews: PreviewProvider {
    static var previews: some View {
        OnDate(.constant(nil))
    }
}
