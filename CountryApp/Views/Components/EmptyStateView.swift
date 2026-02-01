//
//  EmptyStateView.swift
//  CountryApp
//
//  Created by Zeinab Bachir on 31/08/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let text: String
    var color: Color = .secondary
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundColor(color)
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundColor(color)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
