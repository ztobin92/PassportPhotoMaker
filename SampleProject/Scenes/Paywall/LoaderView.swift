//
//  LoaderView.swift
//  AirShareKit
//
//  Created by Furkan Hanci on 1/11/23.
//

import SwiftUI

struct LoadingView: View {

    @Binding var isLoading: Bool

    // MARK: - Main rendering function
    var body: some View {
        return ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.2)
                ProgressView()
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }
        .allowsHitTesting(isLoading)
        .colorScheme(.light)
    }
}
