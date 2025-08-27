//
//  HeaderForAll.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import SwiftUI

struct HeaderForAll: View {
    @State var titleText : String
    var body: some View {
        VStack{
                ZStack{
                    UnevenRoundedRectangle(cornerRadii: .init(
                        bottomLeading:   20.0 ,
                        bottomTrailing:   20.0
                    ))
                    .foregroundStyle(LinearGradient(colors: [Color("LinearOne"), Color("LinearTwo")], startPoint: .leading, endPoint: .trailing))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.15)
                    Text(titleText).foregroundColor(.white).font(.title3.bold()).padding(.top, 20)
                }.edgesIgnoringSafeArea(.top)
            Spacer()
               
        }.background(.clear)
       
    }
}

#Preview {
    HeaderForAll(titleText: "Explore All Command Categories")
}
