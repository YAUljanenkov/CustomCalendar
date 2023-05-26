//
//  ContentView.swift
//  CustomCalendar
//
//  Created by Ярослав Ульяненков on 26.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = true
    @State var date = Date()
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                Text("Выбранная дата:")
                Text(formatDate())
                Button("Открыть календарь") {
                    isPresented = true
                }
            }
            .padding()
            .sheet(isPresented: $isPresented) {
                MyCalendar(isPresented: $isPresented, date: $date, currentDate: date)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
