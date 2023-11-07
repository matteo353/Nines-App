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
    var current_score: Int
    var total_score: Int
    var total_strokes: Int
}

struct Round: Identifiable {
    let id = UUID() // Unique identifier for each round
    var holeNumber: Int
    var playerScores: [Player]
}

