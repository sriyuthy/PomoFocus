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
    @Published var timerStringValue: String = "25:00"
    @Published var isStarted: Bool = false
    
    @Published var minute: Int = 25
    @Published var second: Int = 0
    
    @Published var originalMin: Int = 25
    @Published var originalSec: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    private var timer: Timer?
    
    @Published var completedSessions: Int = 0
    @Published var sessionDots: [Bool] = Array(repeating:false, count: 4)
    
    //Update display string with minutes and seconds
    func updateTimerString(minute: Int, second: Int) {
        //Converts to formatted string
        let minStr = String(format: "%02d", minute) // % - format specifier (substitute val), 0 - padding with leading zeroes, 2 - num digits, d - decimal integer
        let secStr = String(format: "%02d", second)
        //Update display string
        timerStringValue = "\(minStr):\(secStr)"
        
        //print(timerStringValue)
        
    }
    
    func updateStandardTime(minute: Int, second: Int) {
        
        originalMin = minute
        originalSec = second
        //print("updated original times with \(minute) and \(second)")
        
        
    }
    
    //Set timer from string
    func setTime(from string: String) {
        //Split input string on colon into array
        let parts = string.split(separator: ":").map { Int($0) ?? 0}
        //If there's minutes and seconds:
        if parts.count == 2 {
            
            self.minute = parts[0]
            self.second = parts[1]
            updateTimerString(minute: minute, second: second)
            
        }
    }
    
    //Update time from values picked in UI
    func setTime(minute: Int, second: Int) {
        
        self.minute = minute
        self.second = second
        updateStandardTime(minute: minute, second: second)
        updateTimerString(minute: minute, second: second)
        
    }
    
    func resetForNextSession() {
        
        //print("resetting for next session")
        //print("original min is \(originalMin) and original second is \(originalSec)")
        updateTimerString(minute: originalMin, second: originalSec)
        setTime(minute: originalMin, second: originalSec)
        
    }
    
    func completeSession() {
        
        
        sessionDots[completedSessions] = true
        completedSessions += 1
        //print("Completed sessions: \(completedSessions)")
        startBreakTimer()
        resetForNextSession()
        
    }
    
    
    func resetSessions() {
        
        completedSessions = 0
        sessionDots = Array(repeating: false, count: 4)
        
    }
    
    //update timer values
    func updateTimer() {
        totalSeconds -= 1
        minute = (totalSeconds / 60) % 60
        second = totalSeconds % 60
        updateTimerString(minute: minute, second: second)
        
        
        if minute == 0 && second == 0 {
            isStarted = false
            stopTimer()
            completeSession()
            startBreakTimer()
        }
        
        //If timer runs out, print "Finished"
        if completedSessions == sessionDots.count {
            
            print("Finished")
            
        }
    }
    
    //Method to start timer
    func startTimer() {
        //if timer is already started, return from method
        if isStarted {
            return
        }
        
        //Calculates total amount of seconds
        totalSeconds = (minute * 60) + second
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
    
    func startBreakTimer() {
        
        
        
    }
        
        
        
        
        
}

