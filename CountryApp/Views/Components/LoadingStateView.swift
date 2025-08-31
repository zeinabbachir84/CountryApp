//
//  LoadingStateView.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 31/08/2025.
//

import SwiftUI

struct LoadingStateView: View {
    let systemImage: String
    let text: String
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Label {
                Text(text).multilineTextAlignment(.center)
            } icon: {
                Image(systemName: systemImage)
            }
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
