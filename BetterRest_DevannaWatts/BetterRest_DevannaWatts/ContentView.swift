//
//  ContentView.swift
//  BetterRest_DevannaWatts
//
//  The @State properties are used to store the user's input and the calculated bedtime.
// The defaultWakeTime static variable provides a default wake-up time.
// The body property defines the layout of the app, including the input fields and the calculate button.
// The calculateBedtime() function uses a Core ML model (SleepCalculator) to predict the ideal bedtime based on the user's input.
// An alert is displayed with the calculated bedtime or an error message if the calculation fails.
//
//
//  Created by Devanna Temple Watts on 2/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }

                Section(header: Text("Daily coffee intake")) {
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1..<21) { number in
                            Text("\(number) cup\(number > 1 ? "s" : "")")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                Section(header: Text("Recommended Bedtime")) {
                    Text(calculateBedtime())
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }

    func calculateBedtime() -> String {
        let bedtimeHour = (wakeUp.get(.hour) + Int(sleepAmount) + (coffeeAmount * 2)) % 24
        return "\(bedtimeHour):00"
    }
}

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
