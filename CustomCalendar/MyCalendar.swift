//
//  MyCalendar.swift
//  CustomCalendar
//
//  Created by Ярослав Ульяненков on 26.05.2023.
//
import Foundation
import SwiftUI

struct MyCalendar: View {
    var isPresented: Binding<Bool>
    var date: Binding<Date>
    private var currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
    private static let spacing = 34.0
    private var gridItemLayout = [GridItem(.fixed(spacing)), GridItem(.fixed(spacing)), GridItem(.fixed(spacing)), GridItem(.fixed(spacing)), GridItem(.fixed(spacing)), GridItem(.fixed(spacing)), GridItem(.fixed(spacing))]
    
    @State var selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: Date()) {
        didSet{
            let shift = [Int](repeating: 0, count: (getShift() - 1) %% 7)
            let days = Array(1...getDaysInMonth())
            var result:[Int] = []
            result.append(contentsOf: shift)
            result.append(contentsOf: days)
            daysOfMonth = Array(result.enumerated())
            calendarHeight = Int(ceil(Double(daysOfMonth.count) / 7.0))
        }
    }
    @State var daysOfMonth = Array(Array(1...31).enumerated())
    @State var calendarHeight = 5
    
    init(isPresented: Binding<Bool>, date: Binding<Date>, currentDate: Date?) {
        self.isPresented = isPresented
        self.date = date
        if let currentDate = currentDate {
            self.selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: currentDate)
        }
    }
    
    func getMonth() -> String {
        guard let month = selectedDate.month else { return Months.January.rawValue }
        return Months.allCases[(month - 1) %% 12].rawValue
    }
    
    func getShift() -> Int {
        var comps = DateComponents()
        comps.day = 1
        comps.month = selectedDate.month
        comps.year = selectedDate.year
        guard let date = Calendar.current.date(from: comps) else {
            return 0
        }
        return Calendar.current.component(.weekday, from: date) - 1
    }
    
    func getDaysInMonth() -> Int {
        guard let date = Calendar.current.date(from: self.selectedDate) else {
            return 0
        }
        guard let interval = Calendar.current.dateInterval(of: .month, for: date) else {
            return 0
        }
        guard let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day else {
            return 0
        }
        
        return days
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 20.0) {
                    Button {
                        guard let year = selectedDate.year else { return }
                        selectedDate.year = year - 1
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    Text(String(selectedDate.year ?? 0))
                    Button {
                        guard let year = selectedDate.year else { return }
                        selectedDate.year = year + 1
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                HStack(spacing: 10.0) {
                    Button {
                        guard var month = selectedDate.month else { return }
                        month = (month - 1) %% 13
                        if month == 0 {
                            month = 1
                        }
                        selectedDate.month = month
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    Text(getMonth())
                    Button {
                        guard var month = selectedDate.month else { return }
                        month = (month + 1) %% 13
                        if month == 0 {
                            month = 1
                        }
                        selectedDate.month = month
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }
                VStack(alignment: .center, spacing: 20.0) {
                    HStack(spacing: 22.0) {
                        ForEach(0..<5) { i in
                            Text(Days.allCases[i].rawValue)
                        }
                        ForEach(5..<7) { i in
                            Text(Days.allCases[i].rawValue)
                                .italic()
                        }
                    }
                    LazyVGrid(columns: gridItemLayout) {
                        ForEach(daysOfMonth, id: \.offset) { item in
                            Button {
                                selectedDate.day = item.element
                            } label: {
                                Text("\(item.element == 0 ? "" : "\(item.element)")")
                                    .bold(item.element == currentDate.day && selectedDate.month == currentDate.month && selectedDate.year == currentDate.year)
                            }
                            .foregroundColor(item.element == selectedDate.day ? Color.primary : Color.secondary)
                            .disabled(item.element == 0)
                            .frame(width: 24, height: 24, alignment: .center)
                        }
                    }
                }
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        isPresented.wrappedValue.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Выбрать") {
                        guard let newDate = Calendar.current.date(from: self.selectedDate) else {
                            isPresented.wrappedValue.toggle()
                            return
                        }
                        date.wrappedValue = newDate
                        isPresented.wrappedValue.toggle()
                    }
                }
            }
        }
    }
}
