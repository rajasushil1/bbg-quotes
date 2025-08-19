//
//  FeedPage.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 19/08/2025.
//

import SwiftUI

struct FeedPage: View {
    var body: some View {
        TikTokQuotesFeed(quotes: Quote.samples)
    }
}

#Preview {
    FeedPage()
}
