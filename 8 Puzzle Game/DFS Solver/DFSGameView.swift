//
//  DFSGameView.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/4/24.
//

import SwiftUI

struct DFSGameView: View {
    @StateObject private var dfsPuzzleViewModel = DFSPuzzleViewModel()

    var body: some View {
        VStack {
            PuzzleBoardView(tiles: dfsPuzzleViewModel.currentState.tiles)
                .padding()

            if dfsPuzzleViewModel.isSolving {
                Text("Solving Step \(dfsPuzzleViewModel.currentStep + 1)")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()

                PuzzleBoardView(tiles: dfsPuzzleViewModel.solutionSteps[dfsPuzzleViewModel.currentStep].tiles)
                    .padding()

                Button("Next Step") {
                    dfsPuzzleViewModel.nextStep()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.blue)
                )
                .foregroundColor(.white)
                .padding()

            } else {
                Button(action: {
                    dfsPuzzleViewModel.startSolving()
                }) {
                    Text("Start Solving")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
                .foregroundColor(.white)
                .padding()
            }
        }
    }
}


#Preview {
    DFSGameView()
}
