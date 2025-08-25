//
//  ContentView.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var slokaViewModel = SlokaViewModel()
    
    var body: some View {
        ChapterGridView(viewModel: slokaViewModel)
    }
}

#Preview {
    ContentView()
}
