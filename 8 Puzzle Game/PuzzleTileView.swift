//
//  PuzzleTileView.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/3/24.
//

import SwiftUI

struct PuzzleTileView: View {
    let value: Int
    
    private var tileView: some View {
            Rectangle()
                .frame(width: 50, height: 50)
                .background(
                    Color(red: 165 / 255, green: 42 / 255, blue: 42 / 255) // Brown color
                )
                .cornerRadius(8)
                .padding(4)
        }

        var body: some View {
            if value == 0 {
                // Show an empty placeholder for value 0
                tileView
            } else {
                // Show the tile with value
                tileView
                    .overlay(
                        Text("\(value)")
                            .foregroundColor(.white)
                    )
                    .transition(.slide)
            }
        }
        
        
        
    
}

#Preview {
    PuzzleTileView(value: 1)
}
