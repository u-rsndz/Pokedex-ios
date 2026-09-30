//
//  StatView.swift
//  PokeDex
//
//  Created by Uriel on 29/09/26.
//

import Foundation
import SwiftUI

public struct StatView: View {
    public let title: String
    public let value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            Color.secondary.opacity(0.1)
        )
        .cornerRadius(12)
    }
}
