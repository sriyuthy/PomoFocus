//
//  PageState.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/22/25.
//

import Foundation
import SwiftUI

//page state creates a shareable variable that can be accessed by all files
class PageState : ObservableObject {
    //Tracks if user is editing timer
    @Published var isEditing = false
    
    @Published var isEditingText = false
    
}

