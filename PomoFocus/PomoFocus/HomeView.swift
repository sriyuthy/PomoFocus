//
//  HomeView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/5/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        
        let pomodoroModel = PomodoroModel()
        
        Text("Welcome to Home").tag(0)
        
        Text(pomodoroModel.timerStringValue).tag(0)
            
        

        
        
    }
    
    
    
    
}
