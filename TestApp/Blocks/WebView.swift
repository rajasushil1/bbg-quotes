//
//  WebView.swift
//  TestApp
//
//  Created by Raja Sushil Adhikari on 27/08/2025.
//

import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlString) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
