//
//  GameCode.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/2/24.
//

import Foundation

// A typealias for a normal integer array using Swift Array for convenience
typealias IntArray = [Int]

// Represents the state of the puzzle
struct State: Hashable {
    var tiles: IntArray
    let rowsOrCols: Int
    
    init(rowsOrCols: Int) {
        self.rowsOrCols = rowsOrCols
        self.tiles = Array(0..<rowsOrCols * rowsOrCols)
    }
    
    init(rowsOrCols: Int, tiles: IntArray) {
        self.rowsOrCols = rowsOrCols
        self.tiles = tiles
        assert(tiles.count == rowsOrCols * rowsOrCols, "Invalid number of tiles in the initial state")
    }
    
    // Copy constructor
    init(_ other: State) {
        self.rowsOrCols = other.rowsOrCols
        self.tiles = other.tiles
    }
    
    // Equal to operator. This will check item by item.
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.tiles == rhs.tiles
    }
    
    // Not equal to operator. This will check item by item.
    static func != (lhs: State, rhs: State) -> Bool {
        return lhs.tiles != rhs.tiles
    }
    
    // Find the index of the empty slot
    func findZeroIndex() -> Int {
        return tiles.firstIndex(of: 0) ?? tiles.count      // searches for the first occurrence of the value 0 in the array and returns its index
    }
    
    // Randomize the state
    mutating func randomize() {
        tiles.shuffle()
    }
    
    // Swap the values of the indices
    mutating func swapIndices(_ i0: Int, _ i1: Int) {
        tiles.swapAt(i0, i1)
    }
    
    // Get the Hamming cost
    func getHammingCost() -> Int {
        var cost = 0
        for (index, value) in tiles.enumerated() {
            if value == 0 { continue }
            if value != index + 1 { cost += 1 }
        }
        return cost
    }
    
    // Get the Manhattan cost
    func getManhattanCost() -> Int {
        var cost = 0
        for (index, value) in tiles.enumerated() {
            if value == 0 { continue }
            let goalIndex = value - 1
            let goalRow = goalIndex / rowsOrCols
            let goalCol = goalIndex % rowsOrCols
            let currentRow = index / rowsOrCols
            let currentCol = index % rowsOrCols
            cost += abs(currentRow - goalRow) + abs(currentCol - goalCol)
        }
        return cost
    }
    
    
    // Print the puzzle state
    func printState() {
        for i in 0..<rowsOrCols {
            let row = tiles[i * rowsOrCols..<(i + 1) * rowsOrCols]
            print(row.map { $0 == 0 ? " " : String($0) }.joined(separator: " | "))
            if i < rowsOrCols - 1 {
                print("---------")
            }
        }
        print("\n")
    }
}

// Represents a node in the search tree
class Node {
    let state: State
    let parent: Node?
    let depth: Int
    let manhattanCost: Int
    let hammingCost: Int
    
    init(state: State, parent: Node?, depth: Int) {
        self.state = state
        self.parent = parent
        self.depth = depth
        self.manhattanCost = state.getManhattanCost()
        self.hammingCost = state.getHammingCost()
    }
}

// A priority queue implementation for the A* algorithm
struct PriorityQueue<T> {
    private var elements: [T]
    private let priorityFunction: (T, T) -> Bool

    init(ascending: Bool = false, startingValues: [T] = [], priorityFunction: @escaping (T, T) -> Bool) {
        self.elements = startingValues
        self.priorityFunction = ascending ? priorityFunction : { !priorityFunction($0, $1) }
        buildHeap()
    }

    mutating func enqueue(_ element: T) {
        elements.append(element)
        siftUp()
    }

    mutating func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        if elements.count == 1 {
            return elements.removeFirst()
        }
        let first = elements.first
        elements[0] = elements.removeLast()
        siftDown(index: 0)
        return first
    }

    private mutating func siftUp() {
        var child = elements.count - 1
        var parent = parentIndex(of: child)
        while child > 0 && priorityFunction(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(of: child)
        }
    }

    private mutating func siftDown(index: Int) {
        var parent = index
        while true {
            let leftChild = leftChildIndex(of: parent)
            let rightChild = rightChildIndex(of: parent)
            var candidate = parent
            if leftChild < elements.count && priorityFunction(elements[leftChild], elements[candidate]) {
                candidate = leftChild
            }
            if rightChild < elements.count && priorityFunction(elements[rightChild], elements[candidate]) {
                candidate = rightChild
            }
            if candidate == parent {
                return
            }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }


    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }

    private mutating func buildHeap() {
        for i in stride(from: (elements.count / 2 - 1), through: 0, by: -1) {
            siftDown(index: i)
        }
    }
}

// The A* search algorithm implementation
struct PuzzleSolver {
    static func aStar(initialState: State, goalState: State) -> [State] {
        var openSet = PriorityQueue<Node>(startingValues: [Node(state: initialState, parent: nil, depth: 0)],
                                           priorityFunction: { $0.manhattanCost + $0.depth < $1.manhattanCost + $1.depth })
        var cameFrom: [State: State] = [:]
        var gScore: [State: Int] = [initialState: 0]

        while let current = openSet.dequeue()?.state {
            if current == goalState {
                // Reconstruct the path
                var path = [current]
                var reconstructState = current
                while let previous = cameFrom[reconstructState] {
                    path.insert(previous, at: 0)
                    reconstructState = previous
                }
                return path
            }

            // Generate neighbors
            let neighbors = generateNeighbors(current: current)

            for neighbor in neighbors {
                // Calculate tentative gScore
                let tentativeGScore = gScore[current, default: Int.max] + 1

                if tentativeGScore < gScore[neighbor, default: Int.max] {
                    // Update cameFrom and gScore
                    cameFrom[neighbor] = current
                    gScore[neighbor] = tentativeGScore

                    // Enqueue the neighbor with its fScore
                    openSet.enqueue(Node(state: neighbor, parent: nil, depth: 0))
                }
            }
        }

        // If the open set is empty and no solution is found
        return []
    }

    static func generateNeighbors(current: State) -> [State] {
        var neighbors: [State] = []

        let zeroIndex = current.findZeroIndex()
        let zeroRow = zeroIndex / current.rowsOrCols
        let zeroCol = zeroIndex % current.rowsOrCols

        let moves = [(0, -1), (-1, 0), (0, 1), (1, 0)] // Up, Left, Down, Right

        for move in moves {
            let newRow = zeroRow + move.0
            let newCol = zeroCol + move.1

            if (0..<current.rowsOrCols).contains(newRow) && (0..<current.rowsOrCols).contains(newCol) {
                var newTiles = current.tiles
                let newIndex = newRow * current.rowsOrCols + newCol
                newTiles.swapAt(zeroIndex, newIndex)
                neighbors.append(State(rowsOrCols: current.rowsOrCols, tiles: newTiles))
            }
        }

        return neighbors
    }
}

// Main function for testing
func main() {
    let goalState = State(rowsOrCols: 3, tiles: [1, 2, 3, 4, 5, 6, 7, 8, 0])
    let startState = State(rowsOrCols: 3, tiles: [3, 7, 8, 2, 0, 6, 4, 5, 1])

    let puzzleResult = PuzzleSolver.aStar(initialState: startState, goalState: goalState)

    // Print the initial state
    print("Initial State:")
    startState.printState()

    // Print the solution
    if puzzleResult.isEmpty {
        print("No solution found.")
    } else {
        print("Solution:")
        for (index, state) in puzzleResult.enumerated() {
            print("Step \(index + 1):")
            state.printState()
        }
    }
}

// Run the main function

