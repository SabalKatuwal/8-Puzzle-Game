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
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                PuzzleBoardView(tiles: puzzleSolver.isSolving ?
                                puzzleSolver.solutionSteps[puzzleSolver.currentStep].tiles :
                                puzzleSolver.currentState.tiles)
                    .padding()

                if puzzleSolver.isSolving {
                    Text("Solving Step \(puzzleSolver.currentStep + 1)")
                        .font(.title)
                        .padding()

                    Button("Next Step") {
                        puzzleSolver.nextStep()
                    }
                    .padding()
                } else {
                    Button("Start Solving") {
                        puzzleSolver.startSolving()

                        // Use Timer to automatically advance steps every 2 seconds
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            puzzleSolver.nextStep()

                            // Stop the timer when all steps are completed
                            if puzzleSolver.currentStep == puzzleSolver.solutionSteps.count - 1 {
                                timer.invalidate()
                                //
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}

