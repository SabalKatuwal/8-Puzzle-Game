//
//  DFSViewModel.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/4/24.
//

import Foundation
import SwiftUI

class DFSPuzzleViewModel: ObservableObject {
    @Published var currentState: DFSPuzzleState
    @Published var isSolving: Bool = false
    @Published var solutionSteps: [DFSPuzzleState] = []
    @Published var currentStep: Int = 0
    
    private var dfsPuzzleSolver = DFSPuzzleSolver()
    
    init() {
        currentState = DFSPuzzleState(rowsOrCols: 3, tiles: [3, 7, 8, 2, 0, 6, 4, 5, 1])
    }
    
    func startSolving() {
        isSolving = true
        let goalState = DFSPuzzleState(rowsOrCols: 3, tiles: [1, 2, 3, 4, 5, 6, 7, 8, 0]) // Replace with your actual goal state
        solutionSteps = dfsPuzzleSolver.solvePuzzle(initialState: currentState, goalState: goalState)
        currentStep = 0
    }
    
    func nextStep() {
        if currentStep < solutionSteps.count - 1 {
            currentStep += 1
        }
    }
}
