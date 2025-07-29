//
//  BreakView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/22/25.
//

import Foundation
import SwiftUI

struct BreakView: View {
    @StateObject private var pomodoroModel = PomodoroModel()
    
    //Creates environment object for page state
    @EnvironmentObject var pageState : PageState
    
    //Shared variable for tracking glass effect
    @Binding var showGlassEffect: Bool
    
    var body: some View {
        
        ZStack() {
            //Click off menu to finish editing covers entire background
            //Invisible
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture {
                    
                    if pageState.isEditing {
                        //Exit editing mode when tapping the background
                        pomodoroModel.setTime(minute: pomodoroModel.minute, second: pomodoroModel.second)
                        pageState.isEditing = false
                        showGlassEffect = false
                        
                    }
                    else if pomodoroModel.isStarted {
                        
                        showGlassEffect = true
                        pomodoroModel.stopTimer()
                        //print("trying to start the timer again!")
                        
                    }
                    else {
                        
                        pomodoroModel.startTimer()
                        
                    }
                    
                    
                    
                }
            
            
            //Main vertical layout
            VStack() {
                
                //Timer display section
                ZStack() {
                    
                    //If editing, show rectangle
                    if pageState.isEditing {
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray)
                            .frame(width: 320, height: 200)
                                                
                        //Layout for min/sec wheels
                        HStack(spacing: 10) {
                            
                            //Spinning wheel to select minutes
                            Picker("Minutes", selection: $pomodoroModel.minute) {
                                //Creates a text item for each minute in between 0 and 60
                                ForEach(0..<60) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 200, height: 200)
                            
                            //Same thing but for seconds
                            Picker("Seconds", selection: $pomodoroModel.second) {
                                //Creates a text item for each minute in between 0 and 60
                                ForEach(0..<60) { second in
                                    Text("\(second) sec").tag(second)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100, height: 100)
                        }
                        //on tap gesture for pickers is first recognized by this, which does nothing, as opposed to the one in the background
                        .onTapGesture {
                            //Do nothing
                        }
                        
                        
                    } //if statement ending
                    else {
                        //Default timer string
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 80, weight: .bold))
                        //when you press down on timer, goes into edit mode
                            .onLongPressGesture {
                                
                                //haptic feedback
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                pageState.isEditing = true
                            }
                    } //else ending
                } //ZStack ending
                .frame(height: 200)
                .offset(y: 275)
                
                
                
                //Task description editor
                Text("Break")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25, weight: .regular))
                    .padding(.top, 10)
                    .padding(.horizontal)
                
                //Dots
                HStack(spacing: 15) {
                    Circle()
                        .fill(pomodoroModel.sessionDots[0] == true ? Color.black : Color.gray)
                        .frame(width: 15, height: 15)
                        .offset(y: 190)
                    
                    Circle()
                        .fill(pomodoroModel.sessionDots[1] == true ? Color.black : Color.gray)
                        .frame(width: 15, height: 15)
                        .offset(y: 190)
                    
                    Circle()
                        .fill(pomodoroModel.sessionDots[2] == true ? Color.black : Color.gray)
                        .frame(width: 15, height: 15)
                        .offset(y: 190)
                    
                    Circle()
                        .fill(pomodoroModel.sessionDots[3] == true ? Color.black : Color.gray)
                        .frame(width: 15, height: 15)
                        .offset(y: 190)
                    
                }
                .padding(.horizontal, 5)
                
                //Pushes everything afterwards down
                Spacer()
                
            } //VStack ending - main vertical layout
            .animation(.easeInOut, value: pageState.isEditing)
            
        } //ZStack ending - root
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        
        
        
    }
}

#Preview {
    BreakView(showGlassEffect: .constant(false))
        .environmentObject(PageState()) // Provide the missing PageState environment object
}
