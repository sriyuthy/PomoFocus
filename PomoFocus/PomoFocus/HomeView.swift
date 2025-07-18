//
//  HomeView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/5/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var pomodoroModel = PomodoroModel()
    @State var textInput = ""
    //True if user is editing timer
    @State var isEditing = false
    //True if user is editing text field
    @FocusState var isEditingText: Bool
    //True if user is not editing aspects of timer
    var isReady: Bool {
        
        return !isEditing && !isEditingText
        
    }
    
    var body: some View {
        
        ZStack() {
            
            //Click off menu to finish editing covers entire background
            if isEditing {
                //Invisible
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        //Exit editing mode when tapping the background
                        pomodoroModel.setTime(minute: pomodoroModel.minute, second: pomodoroModel.second)
                        isEditing = false
                    }
            }
            
            //Main vertical layout
            VStack() {
                
                //Timer display section
                ZStack() {
                    
                    //If editing, show rectangle
                    if isEditing {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
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
                    }
                    else {
                        //Default timer string
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 80, weight: .bold))
                            //when you press down on timer, goes into edit mode
                            .onLongPressGesture {
                                
                                //haptic feedback
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                
                                isEditing = true
                            }
                    }
                }
                .frame(height: 200)
                .offset(y: 275)
                
                //Task description editor
                TextField("Enter task description", text: $textInput)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25, weight: .regular))
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .focused($isEditingText)
                
                //Dots
                Circle()
                    .frame(width: 15, height: 15)
                    
                //Pushes everything afterwards down
                Spacer()
                
                //Tap to continue
                if isReady {
                    Text("Tap to continue")
                        .padding(.bottom)

                }
                            }
        }
        .animation(.easeInOut, value: isEditing)
    }
}
