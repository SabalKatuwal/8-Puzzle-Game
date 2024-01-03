//
//  PuzzleTileView.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/3/24.
//

import SwiftUI

struct PuzzleTileView: View {
    let value: Int

    var body: some View {
        
        Image("textureImage")
            .resizable()
            .frame(width: 80, height: 80)
            .overlay {
                if value != 0 {
                    Text("\(value)")
                        .bold()
                        .font(.system(size: 45))
                        .foregroundStyle(Color.blue)
                }
            }
            .opacity(value == 0 ? 0 : 1)
            
        
    }
        
        
        
    
}

#Preview {
    PuzzleTileView(value: 1)
}
