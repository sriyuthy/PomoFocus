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
    
    var body: some View {
        //positioning of tabs
        ZStack(alignment: .top) {
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
            }
            
            //Tab view to swipe between pages
            TabView(selection: $selectedPage) {
                
                HomeView().tag(0)
                
                MemoriesView().tag(1)
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) //hide dots at the bottom
            
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
        }
        
    }
}

#Preview {
    ContentView()
}
