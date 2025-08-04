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
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var justOpened = false
    
    @State private var showText = false
        
    var body: some View {
        //positioning of tabs
        ZStack(alignment: .top) {
            
            //Tab view to swipe between pages
            TabView(selection: $selectedPage) {
                
                //pass pomodoro model to homeview, also tracks page state and showGlassEffect
                HomeView(pomodoroModel:pomodoroModel, showGlassEffect: $showGlassEffect)
                    .environmentObject(pageState)
                    .tag(0)
                
                
                MemoriesView().tag(1)
                
            }
            
            //Shrinks tab after 0.75 seconds after opening app
            .onChange(of: scenePhase) { oldPhase, newPhase in
                
                if newPhase == .active {
                    
                    justOpened = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isExpanded = false
                        }
                        
                        justOpened = false
                        
                    }
                    
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) //hide dots at the bottom
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if selectedPage == 2 {
                            return
                        }
                    }
            )
            
            
            //.offset(y:100)
            
            
            //Handles tab expansion/shrinking
            .onChange(of: selectedPage) {
                let newValue = selectedPage
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded = true
                }
                
                //Tab shrinks after 0.75 seconds if selected page and new page are the same
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    
                    if justOpened || selectedPage == newValue {
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
                .onTapGesture {
                    
                    pomodoroModel.startTimer()
                    showGlassEffect = false
                    
                }
            
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
                            .font(.custom("Inter", size: 17))
                            //.font(.system(size: 17))
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
                            .font(.custom("Inter", size: 17))
                        : Text("")
                            .foregroundColor(.white)
                    )
                    .animation(.easeInOut(duration: 0.1), value: selectedPage)
                
            } //HStack ending
            .padding(.top)
            .offset(y:50)
            
            // Text that appears at the bottom
            VStack {
                    
                //If timer hasnt started then tap to continue appears, else tap to stop appears
                    Text("Tap to start")
                        .font(.custom("Inter", size: 17))
                        .foregroundColor(.gray)
                        .opacity((pageState.isEditingText || pomodoroModel.isStarted || pageState.isEditing) ? 0: 1)
                        .animation(.easeInOut(duration: 0.1), value: pageState.isEditingText)
                        .offset(y:775)
                    
                
                    Text("Tap to stop")
                        .font(.custom("Inter", size: 17))
                        .foregroundColor(.gray)
                        .opacity(pomodoroModel.isStarted ? 1 : 0)
                        .offset(y:753)
                    
                }
                
                if !pageState.isEditing && showGlassEffect == true {
                    
                    //exit emoji
                    Button(action: {
                        showGlassEffect = false
                        
                        pomodoroModel.resetForNextSession()
                    }
                           
                    ) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title)
                            .opacity(showText ? 1 : 0)
                            .animation(.easeInOut(duration: 1.2), value: showText)
                    }
                    .position(x: 200, y:130)
                }

            }
                        
            
            
            
        
        .onChange(of: showGlassEffect) { oldValue, newValue in
            
            if newValue {
                showText = true
            }
            else {
                showText = false
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()

        
    }
        
}

        
#Preview {
    ContentView()
}
