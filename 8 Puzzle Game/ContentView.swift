//
//  ContentView.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/2/24.
//

import SwiftUI

struct ContentView: View {
     
    @StateObject private var puzzleSolver = PuzzleSolverViewModel()

    var body: some View {
        VStack {
            PuzzleBoardView(tiles: puzzleSolver.currentState.tiles)

            if puzzleSolver.isSolving {
                Text("Solving Step \(puzzleSolver.currentStep + 1)")
                    .font(.title)
                    .padding()

                PuzzleBoardView(tiles: puzzleSolver.solutionSteps[puzzleSolver.currentStep].tiles)
                    .padding()

                Button("Next Step") {
                    puzzleSolver.nextStep()
                }
                .padding()
            } else {
                Button("Start Solving") {
                    puzzleSolver.startSolving()
                }
                .padding()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
