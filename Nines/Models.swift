//
//  Models.swift
//  Nines
//
//  Created by Matteo Mastandrea on 10/30/23.
//

import Foundation

struct Player: Identifiable {
    let id = UUID() // Unique identifier for each player
    var name: String
    var score: Int
}

struct Round: Identifiable {
    let id = UUID() // Unique identifier for each round
    var holeNumber: Int
    var playerScores: [Player]
}

