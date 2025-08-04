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
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    for family in UIFont.familyNames.sorted() {
                        print("Family: \(family)")
                        for name in UIFont.fontNames(forFamilyName: family) {
                            print("    Font: \(name)")
                        }
                    }
                }
        }
    }
    
            
}
