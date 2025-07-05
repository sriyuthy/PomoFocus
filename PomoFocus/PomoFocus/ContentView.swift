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
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedPage == 0 ? Color.black : Color.gray)
                .frame(
                    width: 175,
                    height: selectedPage == 0 ? 20 : 10)
                .overlay(
                    selectedPage == 0 ?
                        Text("Home")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                    : Text("")
                        .foregroundColor(.white)
                )
                .animation(.easeInOut(duration: 0.1), value: selectedPage)
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedPage == 1 ? Color.black : Color.gray)
                .frame(
                    width: 175,
                    height: selectedPage == 1 ? 20 : 10)
                .overlay(
                    selectedPage == 1 ?
                        Text("Memories")
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                    : Text("")
                        .foregroundColor(.white)
                )
                .animation(.easeInOut(duration: 0.1), value: selectedPage)
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
