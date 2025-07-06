//
//  PomodoroModel.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/5/25.
//

import Foundation

class PomodoroModel {
    //Timer Properties
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "0:00"
    
    @Published var hour: Int = 0
    @Published var minute: Int = 0
    @Published var second: Int = 0
}
