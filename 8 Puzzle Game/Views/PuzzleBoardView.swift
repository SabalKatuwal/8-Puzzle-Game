//
//  PuzzleBoardView.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/3/24.
//

import SwiftUI

struct PuzzleBoardView: View {
    let tiles: [Int]

    let rowsOrCols: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowsOrCols) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.rowsOrCols) { col in
                        withAnimation(.easeInOut) {
                            PuzzleTileView(value: self.tiles[row * self.rowsOrCols + col])
                        }
                    }
                }
            }
        }
        .background(
            Image("boardTexture")
                .resizable()
                .frame(width: 280, height: 280)
        )
    }
}

#Preview {
    PuzzleBoardView(tiles: [1, 2, 3, 4, 5, 6, 7, 8, 0])
}
