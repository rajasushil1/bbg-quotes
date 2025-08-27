//
//  LoadingView.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import Foundation
import SwiftUI
struct LoadingView: View {
    var body: some View {
        HStack {
                DotView()
                DotView(delay: 0.2)
                DotView(delay: 0.4)
        }.background(.clear).foregroundColor(.gray)
    }
}

#Preview {
    LoadingView()
}

struct DotView: View {
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 12, height: 12)
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay))
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}
