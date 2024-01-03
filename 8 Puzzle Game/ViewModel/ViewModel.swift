//
//  ViewModel.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/3/24.
//

import Foundation

class PuzzleSolverViewModel: ObservableObject {
    @Published var currentState: State
    @Published var solutionSteps: [State] = []
    @Published var isSolving = false
    @Published var currentStep = 0

    init() {
        currentState = State(rowsOrCols: 3, tiles: [3, 7, 8, 2, 0, 6, 4, 5, 1])
    }

    func startSolving() {
        isSolving = true
        solutionSteps = PuzzleSolver.aStar(initialState: currentState, goalState: State(rowsOrCols: 3, tiles: [1, 2, 3, 4, 5, 6, 7, 8, 0]))
        currentStep = 0
    }

    func nextStep() {
        if currentStep < solutionSteps.count - 1 {
            currentStep += 1
        } else {
            isSolving = false
        }
    }
    
    func reset() {
        currentState = State(rowsOrCols: 3, tiles: [1, 2, 3, 4, 5, 6, 7, 8, 0])
        solutionSteps = []
        currentStep = 0
        isSolving = false
    }
    
    var isPuzzleSolved: Bool {
        return currentStep == solutionSteps.count - 1
    }
}
