//
//  ContentView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/2/25.
//

import SwiftUI

struct ContentView: View {
    //selected page tracks home as 0 and memories as 1
    @State private var selectedPage = 0
    //Tracks if tabs at top should be expanded or not (20 or 10)
    @State private var isExpanded = true
    //Creates instance of page state class
    @StateObject private var pageState = PageState()
    
    @State private var showGlassEffect = false
    
    @StateObject private var pomodoroModel = PomodoroModel()
    
    var body: some View {
        //positioning of tabs
        ZStack(alignment: .top) {
                        
            //Tab view to swipe between pages
            TabView(selection: $selectedPage) {
                
                //pass pomodoro model to homeview, also tracks page state and showGlassEffect
                HomeView(pomodoroModel:pomodoroModel, showGlassEffect: $showGlassEffect)
                    .environmentObject(pageState)
                    .tag(0)
                
                //if user is editing the timer they can swipe to the otherwise hidden break timer
                if pageState.isEditing {
                    BreakView().tag(0)
                }

                MemoriesView().tag(1)
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) //hide dots at the bottom
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.offset(y:100)
            
            
            //Handles tab expansion/shrinking
            .onChange(of: selectedPage) {
                let newValue = selectedPage
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded = true
                }
                
                //Tab shrinks after 2 seconds if selected page and new page are the same
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    
                    if selectedPage == newValue {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded = false
                        }
                        
                    }
                    
                }
                
            }
            
            //if showGlassEffect is true, then add blur with ease in out animation
            Color.clear                    .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .opacity(showGlassEffect ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showGlassEffect)
            
            HStack {
                //Home tab
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPage == 0 ? Color.black : Color.gray)
                    .frame(
                        width: 175,
                        height: (selectedPage == 0 && isExpanded) ? 20 : 10)
                    .overlay(
                        (selectedPage == 0 && isExpanded) ?
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                        : Text("")
                            .foregroundColor(.white)
                    )
                    .animation(.easeInOut(duration: 0.1), value: selectedPage)
                
                //Memories tab
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPage == 1 ? Color.black : Color.gray)
                    .frame(
                        width: 175,
                        height: (selectedPage == 1 && isExpanded) ? 20 : 10)
                    .overlay(
                        (selectedPage == 1 && isExpanded) ?
                        Text("Memories")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                        : Text("")
                            .foregroundColor(.white)
                    )
                    .animation(.easeInOut(duration: 0.1), value: selectedPage)
                    
            } //HStack ending
            .padding(.top)
            .offset(y:50)

            // Buttons that appear at the bottom (always visible when conditions are met)
            VStack {
                Spacer()
                
                if !pageState.isEditing {
                    if pomodoroModel.isStarted == false {
                        Button("Tap to continue") {
                            pomodoroModel.startTimer()
                            showGlassEffect = false
                        }
                        .padding(.bottom)
                        .foregroundColor(.gray)
                    }
                    
                    if pomodoroModel.isStarted {
                        Button("Tap to stop") {
                            pomodoroModel.stopTimer()
                            showGlassEffect = true
                        }
                        .padding(.bottom)
                        .foregroundColor(.gray)
                    }
                }
                
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        
    }
}

#Preview {
    ContentView()
}
