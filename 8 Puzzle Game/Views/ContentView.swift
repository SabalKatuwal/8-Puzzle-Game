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
            Image("backgroundImage")
                .resizable()
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
                        .foregroundColor(.blue)
                        .padding()
                        .background(
                            Image("boardTexture")
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        )

                    Button("Next Step") {
                        puzzleSolver.nextStep()
                    }
                    .padding()
                    .background(
                        Image("boardTexture")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black, radius: 10, x: 0, y: 2)
                            
                    )
                } else {
                    Button(action: {
                        puzzleSolver.startSolving()

                        // Use Timer to automatically advance steps every 1 seconds
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            puzzleSolver.nextStep()

                            // Stop the timer when all steps are completed
                            if puzzleSolver.currentStep == puzzleSolver.solutionSteps.count - 1 {
                                timer.invalidate()
                            }
                        }
                    }) {
                        Text("Start Solving")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    }
                    .background(
                        Image("boardTexture")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .black, radius: 10, x: 0, y: 2)
                            
                    )
                    .padding()
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}

