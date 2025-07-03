//
//  PomoFocusApp.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/2/25.
//

//test commit

import SwiftUI

@main
struct PomoFocusApp: App {
    let hello = "hey there, first time learning Swift!"
    
    func greet() {
        
        print(hello)

    }
    
    init() {
        
        greet()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
            
}
