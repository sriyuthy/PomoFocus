//
//  ContentView.swift
//  PomoFocus
//
//  Created by Sriyuth Yerramshetty on 7/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPage = 0
    var body: some View {
        HStack {
            Circle()
                .fill(selectedPage == 0 ? Color.black : Color.gray)
            Circle()
                .fill(selectedPage == 1 ? Color.black : Color.gray)
        }
        
        TabView(selection: $selectedPage){
            Text("First page").tag(0)
            Text("Second page").tag(1)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page)
        
        
                    }
}

#Preview {
    ContentView()
}
