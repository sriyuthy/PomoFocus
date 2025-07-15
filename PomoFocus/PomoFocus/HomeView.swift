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
    var body: some View {
        
        ZStack() {
            
            //Main vertical layout
            VStack() {
                
                //Timer display section
                ZStack() {
                    
                    //If editing, show rectangle
                    if isEditing {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 220, height: 100)
                        
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
                            .frame(width: 100, height: 100)
                            
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
                        
                    }
                    else {
                        
                        //Default timer string
                        Text(pomodoroModel.timerStringValue)
                            .font(.system(size: 80, weight: .bold))
                            //when you press down on timer, goes into edit mode
                            .onLongPressGesture {
                                
                                isEditing = true
                                
                            }
                    }
                }
                .offset(y: 275)
                
                //Task description editor
                TextField("Enter task description", text: $textInput)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 25, weight: .regular))
                    .padding(.top, 35)
                    .padding(.horizontal)
                    
                //Pushes everything afterwards down
                Spacer()
                
                //Click "Done" to finish editing
                if isEditing {
                    Button("Done") {
                        
                        pomodoroModel.setTime(minute: pomodoroModel.minute, second: pomodoroModel.second)
                        isEditing = false
                        
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: isEditing)
    }
}
