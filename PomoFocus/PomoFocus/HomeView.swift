//
//  HomeView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/5/25.
//

import Foundation
import SwiftUI

extension Color {
    func lighter(by amount: Double = 0.3) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Increase brightness to make it lighter
        brightness = min(brightness + CGFloat(amount), 1.0)
        
        return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
    }
}


struct HomeView: View {
    
    //Creates environment object for page state
    @EnvironmentObject var pageState : PageState
    
    //Shared instnace of pomodoro model
    @ObservedObject var pomodoroModel : PomodoroModel
    
    @State var textInput = ""
    
    //True if user is editing text field
    //@FocusState var isEditingText: Bool
    
    //Shared variable for tracking glass effect
    @Binding var showGlassEffect: Bool
    
    //True if user is not editing aspects of timer
    var isReady: Bool {
        
        return !pageState.isEditing && !pageState.isEditingText
        
    }
    
    //for tab view
    @State private var selectedTab = 0
    
    //True if timer is started
    @State var isStarted = false
                
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
                        
                        pageState.isPaused = true
                        showGlassEffect = true
                        pomodoroModel.stopTimer()
                        
                        
                        
                        
                    }
                    else {
                        
                        pomodoroModel.startTimer()
                        
                    }
                }
            
            //Main vertical layout
            VStack() {
                
                //Timer display section
                ZStack() {
                    
                    //Dots
                    HStack(spacing: 15) {
                        Circle()
                            .fill(pomodoroModel.sessionDots[0] == true ? Color.green : Color.gray)
                            .frame(width: 15, height: 15)
                            .offset(y: 70)
                        
                        Circle()
                            .fill(pomodoroModel.sessionDots[1] == true ? Color.green : Color.gray)
                            .frame(width: 15, height: 15)
                            .offset(y: 70)
                        
                        Circle()
                            .fill(pomodoroModel.sessionDots[2] == true ? Color.green : Color.gray)
                            .frame(width: 15, height: 15)
                            .offset(y: 70)
                        
                        Circle()
                            .fill(pomodoroModel.sessionDots[3] == true ? Color.green : Color.gray)
                            .frame(width: 15, height: 15)
                            .offset(y: 70)
                        
                    }
                    .padding(.horizontal, 5)
                    
                   
                        Button(action: {
                            pomodoroModel.breakView.toggle()
                            if pomodoroModel.breakView {
                                pomodoroModel.updateTimerString(minute: pomodoroModel.breakMin, second: pomodoroModel.breakSec)
                            }
                            else {
                                pomodoroModel.updateTimerString(minute: pomodoroModel.minute, second: pomodoroModel.second)
                            }
                        }
                        ) {
                            Image(systemName: (pomodoroModel.breakView) ? "house" : "clock")
                                .foregroundColor(.black)
                                .font(.title)
                                
                                
                        }
                        .opacity((!pomodoroModel.isStarted && !pageState.isPaused) ? 1 : 0)
                        .animation(.easeInOut(duration: 0.2), value: !pomodoroModel.isStarted && !pageState.isPaused)
                        .position(x: 200, y: -145)

                    
                    
                    //If editing, show rectangle
                    if pageState.isEditing {
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .frame(width: 320, height: 200)
                        
                        //Layout for min/sec wheels
                        HStack(spacing: 10) {
                            
                            //Spinning wheel to select minutes
                            Picker("Minutes", selection: pomodoroModel.breakView ? $pomodoroModel.breakMin : $pomodoroModel.minute) {
                                //Creates a text item for each minute in between 0 and 60
                                ForEach(0..<60) { minute in
                                    Text("\(minute) min").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 200, height: 200)
                            .onChange(of: pomodoroModel.breakView ? pomodoroModel.breakMin : pomodoroModel.minute) {
                                
                                if pomodoroModel.breakView {
                                    pomodoroModel.setBreakTime(minute: pomodoroModel.breakMin, second: pomodoroModel.breakSec)
                                    pomodoroModel.updateTimerString(minute: pomodoroModel.breakMin, second: pomodoroModel.breakSec)

                                }
                                else {
                                    pomodoroModel.setTime(minute: pomodoroModel.minute, second: pomodoroModel.second)
                                    pomodoroModel.updateTimerString(minute: pomodoroModel.minute, second: pomodoroModel.second)

                                }
                            }
                            
                            //Same thing but for seconds
                            Picker("Seconds", selection: pomodoroModel.breakView ? $pomodoroModel.breakSec: $pomodoroModel.second) {
                                //Creates a text item for each minute in between 0 and 60
                                ForEach(0..<60) { second in
                                    Text("\(second) sec").tag(second)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100, height: 100)
                            .onChange(of: pomodoroModel.breakView ? pomodoroModel.breakSec : pomodoroModel.second) {
                                
                                if pomodoroModel.breakView {
                                    pomodoroModel.setBreakTime(minute: pomodoroModel.breakMin, second: pomodoroModel.breakSec)
                                    pomodoroModel.updateTimerString(minute: pomodoroModel.breakMin, second: pomodoroModel.breakSec)
                                }
                                else {
                                    pomodoroModel.setTime(minute: pomodoroModel.minute, second: pomodoroModel.second)
                                    pomodoroModel.updateTimerString(minute: pomodoroModel.minute, second: pomodoroModel.second)

                                }
                            }
                        }
                        //on tap gesture for pickers is first recognized by this, which does nothing, as opposed to the one in the background
                        .onTapGesture {
                            //Do nothing
                        }
                        
                    } //if statement ending
                    else {
                        //Default timer string
                        Text(pomodoroModel.timerStringValue)
                            //.font(.system(size: 80))
                            .font(.custom("Inter-Regular_Bold", size: 80))
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
                TextField("Enter task description", text: $textInput, onEditingChanged: { editing in
                    pageState.isEditingText = editing
                })
                    .multilineTextAlignment(.center)
                    .font(.custom("Inter", size: 25))
                    .padding(.top, 10)
                    .padding(.horizontal)
                    //.focused($pageState.isEditingText)
                
                                
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
    HomeView(
        pomodoroModel: PomodoroModel(),
        showGlassEffect: .constant(false)
    )
    .environmentObject(PageState()) // Provide the required PageState environment object
}
