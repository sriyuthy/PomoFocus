//
//  PomodoroModel.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/5/25.
//

import Foundation

//Observable - so swift can track changes in the object
class PomodoroModel: ObservableObject {
    //Timer Properties
    //Published - re-render any view that uses this when the value changes
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "30:00"
    @Published var isStarted: Bool = false
    
    @Published var hour: Int = 0
    @Published var minute: Int = 30
    @Published var second: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    private var timer: Timer?
    
    @Published var completedSessions: Int = 0
    @Published var sessionDots: [Bool] = Array(repeating:false, count: 4)
    
    //Update display string with minutes and seconds
    func updateTimerString() {
        //Converts to formatted string
        let minStr = String(format: "%02d", minute) // % - format specifier (substitute val), 0 - padding with leading zeroes, 2 - num digits, d - decimal integer
        let secStr = String(format: "%02d", second)
        //Update display string
        timerStringValue = "\(minStr):\(secStr)"
        
    }
    
    //Set timer from string
    func setTime(from string: String) {
        //Split input string on colon into array
        let parts = string.split(separator: ":").map { Int($0) ?? 0}
        //If there's minutes and seconds:
        if parts.count == 2 {
            
            self.minute = parts[0]
            self.second = parts[1]
            updateTimerString()
            
        }
    }
    
    //Update time from values picked in UI
    func setTime(minute: Int, second: Int) {
        
        self.minute = minute
        self.second = second
        updateTimerString()
        
    }
    
    func completeSession() {
        
        if completedSessions < sessionDots.count {
            
            sessionDots[completedSessions] = true
            completedSessions += 1
            
        }
        
    }
    
    func resetSessions() {
        
        completedSessions = 0
        sessionDots = Array(repeating: false, count: 4)
        
    }
    
    //update timer values
    func updateTimer() {
        totalSeconds -= 1
        hour = totalSeconds / 3600
        minute = (totalSeconds / 60) % 60
        second = totalSeconds % 60
        updateTimerString()
        
        //If timer runs out, print "Finished"
        if hour == 0 && minute == 0 && second == 0 {
            isStarted = false
            print("Finished")
            completeSession()
        }
    }
    
    //Method to start timer
    func startTimer() {
        //if timer is already started, return from method
        if isStarted {
            return
        }
        
        //Calculates total amount of seconds
        totalSeconds = (hour * 3600) + (minute * 60)
        staticTotalSeconds = totalSeconds
        
        //set timer object to update timer every second
        isStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
            
        }
    }
    
        
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        isStarted = false
    }
    
    func addDots() {
        
        
        
    }
        
        
        
        
        
}

