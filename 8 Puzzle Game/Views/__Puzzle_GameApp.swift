//
//  __Puzzle_GameApp.swift
//  8 Puzzle Game
//
//  Created by Sabal on 1/2/24.
//

import SwiftUI

@main
struct __Puzzle_GameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(
                    Image("textureImage")
                        .resizable()
                        .scaledToFill()
                )
        }
    }
}
