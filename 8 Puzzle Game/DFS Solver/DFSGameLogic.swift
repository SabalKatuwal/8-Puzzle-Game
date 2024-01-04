//
//  DFSGameLogic.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/4/24.
//

import Foundation

class DFSPuzzleSolver {
    private var visitedStates: Set<DFSPuzzleState> = []
    
    func solvePuzzle(initialState: DFSPuzzleState, goalState: DFSPuzzleState) -> [DFSPuzzleState] {
        visitedStates.removeAll()
        return depthFirstSearch(currentState: initialState, goalState: goalState)
    }
    
    private func depthFirstSearch(currentState: DFSPuzzleState, goalState: DFSPuzzleState) -> [DFSPuzzleState] {
        // Mark the current state as visited
        visitedStates.insert(currentState)
        
        // Base case: Check if the goal state is reached
        if currentState == goalState {
            return [currentState]
        }
        
        // Generate neighbors
        let neighbors = generateNeighbors(current: currentState)
        
        for neighbor in neighbors {
            if !visitedStates.contains(neighbor) {
                // Recursively explore the neighbor
                let result = depthFirstSearch(currentState: neighbor, goalState: goalState)
                
                // If a solution is found, prepend the current state and return
                if !result.isEmpty {
                    return [currentState] + result
                }
            }
        }
        
        // No solution found for this branch
        return []
    }
    
    private func generateNeighbors(current: DFSPuzzleState) -> [DFSPuzzleState] {
        var neighbors: [DFSPuzzleState] = []

        guard let zeroIndex = current.tiles.firstIndex(of: 0) else {
            // Handle the case where 0 is not found
            return neighbors
        }

        let zeroRow = zeroIndex / current.rowsOrCols
        let zeroCol = zeroIndex % current.rowsOrCols

        let moves = [(0, -1), (-1, 0), (0, 1), (1, 0)] // Up, Left, Down, Right

        for move in moves {
            let newRow = zeroRow + move.0
            let newCol = zeroCol + move.1

            if (0..<current.rowsOrCols).contains(newRow) && (0..<current.rowsOrCols).contains(newCol) {
                let newIndex = newRow * current.rowsOrCols + newCol

                // Check if indices are valid before swapping
                if zeroIndex < current.tiles.count && newIndex < current.tiles.count {
                    var newTiles = current.tiles
                    newTiles.swapAt(zeroIndex, newIndex)
                    neighbors.append(DFSPuzzleState(rowsOrCols: current.rowsOrCols, tiles: newTiles))
                }
            }
        }

        return neighbors
    }
}



//Model
// DFS Puzzle State
struct DFSPuzzleState: Hashable {
    var tiles: [Int]
    let rowsOrCols: Int

    // Add any other properties or methods specific to your puzzle state

    // Example initializer
    init(rowsOrCols: Int, tiles: [Int]) {
        self.rowsOrCols = rowsOrCols
        self.tiles = tiles
    }

    // Example equality operator
    static func == (lhs: DFSPuzzleState, rhs: DFSPuzzleState) -> Bool {
        return lhs.tiles == rhs.tiles
    }

    // Example hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(tiles)
    }
}
