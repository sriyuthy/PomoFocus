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
    
    @State private var showFirstText = true
    
    @State private var isHolding = false
    
    @State private var holdProgress: Double = 0.0
    
    @State private var holdTimer: Timer?
    
    @State private var timerFinished = false
    
    @State private var showConfetti = false
    
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
                .gesture (DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if showGlassEffect && !isHolding {
                            startHoldProgress()
                            
                        }
                    }
                    .onEnded { _ in
                        if isHolding {
                            stopHoldProgress()
                        }
                    }
                )
            
            //Progress bar
            if isHolding && showGlassEffect {
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 100, height: 8)
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .frame(width: 100 * holdProgress, height: 8)
                            
                            Spacer(minLength: 0)
                        }
                        .frame(width: 100)
                    }
                    .padding(.bottom, 65)

                }
                .transition(.opacity)
            }
                

                
            
            HStack {
                //Home tab
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPage == 0 ? Color.black : Color.gray)
                    .frame(
                        width: 175,
                        height: (selectedPage == 0 && isExpanded) ? 22 : 10)
                    .overlay(
                        (selectedPage == 0 && isExpanded) ?
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.custom("Inter-Regular", size: 17))
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
                        height: (selectedPage == 1 && isExpanded) ? 22 : 10)
                    .overlay(
                        (selectedPage == 1 && isExpanded) ?
                        Text("Memories")
                            .foregroundColor(.white)
                            .font(.custom("Inter-Regular", size: 17))
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
                Text(showGlassEffect ? "Tap to resume": "Tap to start")
                        .font(.custom("Inter-Regular", size: 17))
                        .foregroundColor(.gray)
                        .opacity((selectedPage == 1 || pageState.isEditingText || pomodoroModel.isStarted || pageState.isEditing || showGlassEffect) ? 0: 1)
                        .animation(.easeInOut(duration: 0.1), value: pageState.isEditingText)
                        .offset(y:775)
                    
                
                    Text("Tap to stop")
                        .font(.custom("Inter-Regular", size: 17))
                        .foregroundColor(.gray)
                        .opacity((selectedPage == 0 && pomodoroModel.isStarted) ? 1 : 0)
                        .offset(y:754)
                
                if showGlassEffect {
                    Text(showFirstText ? "Tap to resume" : "Hold to reset")
                        .font(.custom("Inter-Regular", size: 17))
                        .foregroundColor(.gray)
                        .opacity(isHolding ? 0 : 1)
                        .frame(width: 200)
                        .animation(.easeInOut(duration: 0.2), value: showFirstText)
                        .offset(y:732)
                        .onAppear() {
                            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true)
                            { timer in
                                if showGlassEffect
                                {
                                    showFirstText.toggle()
                                }
                                else
                                {
                                    timer.invalidate()
                                }
                            }
                        }
                    }
                    
                    
                }
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
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
        .onChange(of: pomodoroModel.completedSessions) { oldValue, newValue in
                if newValue == pomodoroModel.sessionDots.count {
                    print("All sessions complete! Triggering confetti")

                    timerFinished = true
                }
        }
        .onChange(of: timerFinished) { oldValue, newValue in
                    if newValue {
                        triggerConfetti()
                        print("Going to next func!")
                        // Reset the trigger after a delay if needed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            timerFinished = false
                        }
                    }
                }

    } //zstack ending
    
    private func triggerConfetti() {
        print("Got to trigger confetti function!")
            showConfetti = true
            
            // Hide confetti after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                showConfetti = false
            }
        }

    
    
    func startHoldProgress() {
        isHolding = true
        holdProgress = 0.0
        
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            holdProgress += 0.05 / 1.0
            
            if holdProgress >= 1.0 {
                holdProgress = 1.0
                stopHoldProgress()
                onHoldComplete()
            }
        }
    }

    func stopHoldProgress() {
        holdTimer?.invalidate()
        holdTimer = nil
        withAnimation(.easeOut(duration: 0.2)) {
            isHolding = false
        }
        holdProgress = 0.0
    }

    func onHoldComplete() {
        pomodoroModel.resetForNextSession()
        pomodoroModel.stopTimer()
        showGlassEffect = false
    }
        
}

struct ConfettiView: View {
    @State private var animateConfetti = false
    
    var body: some View {
        ZStack {
            ForEach(0..<30, id: \.self) { index in
                ConfettiPiece()
                    .offset(
                        x: animateConfetti ? CGFloat.random(in: -200...200) : CGFloat.random(in: -50...50),
                        y: animateConfetti ? 1000 : -100
                    )
                    .animation(
                        .linear(duration: Double.random(in: 2...4))
                        .delay(Double.random(in: 0...1)),
                        value: animateConfetti
                    )
            }
        }
        .onAppear {
            animateConfetti = true
        }
    }
}

struct ConfettiPiece: View {
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
    @State private var rotation = 0.0
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .red)
            .frame(width: 8, height: 4)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: Double.random(in: 0.5...1.5)).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

        
#Preview {
    ContentView()
}
