//
//  GameViewModel.swift
//  Nines
//
//  Created by Matteo Mastandrea on 10/30/23.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var selectedHoles: String
    @Published var holeScores: [[Int]] // Add this to track hole-by-hole scores
    @Published var currentHole: Int = 1

    init(players: [Player], selectedHoles: String) {
            self.players = players
            self.selectedHoles = selectedHoles

            let holeCount: Int = selectedHoles == "9 holes" ? 9 : 18
        // holeScores[player][hole]
            self.holeScores = Array(repeating: Array(repeating: 0, count: holeCount), count: players.count)
        }

    func updateCard(with scores: [UUID: Int]) {
        // Check array bounds
        guard !players.isEmpty, currentHole > 0 && currentHole <= holeScores[0].count else {
            // Handle the error - maybe show an alert or log the issue.
            return
        }
        
        for (index, player) in players.enumerated() {
            if let holeScore = scores[player.id] {
                // Update the score for the current hole for this player.
                holeScores[index][currentHole - 1] = holeScore
                
                // Update total strokes for the player.
                players[index].total_strokes += holeScore
                
                // Update the total strokes in the last column for each player.
                // Assuming the last column is dedicated to the total strokes.
//                holeScores[index][holeScores[index].count - 1] = players[index].total_strokes
            }
        }
        currentHole += 1
    }

    
    func updateScores(with scores: [UUID: Int]) {
        // Only consider players who have a score for the current hole.
        let scoringPlayers = players.filter { scores[$0.id] != nil }

        // Sort the players based on the current hole's scores, safely unwrapping optionals.
        let sortedPlayers = scoringPlayers.sorted {
            guard let score1 = scores[$0.id], let score2 = scores[$1.id] else { return false }
            return score1 < score2
        }

        // You must ensure that you have exactly three scores here, otherwise, you should not proceed.
        guard sortedPlayers.count == 3 else {
            // Handle the error - maybe show an alert or log the issue.
            return
        }

        // Safely unwrapped scores.
        let firstScore = scores[sortedPlayers[0].id]!
        let secondScore = scores[sortedPlayers[1].id]!
        let thirdScore = scores[sortedPlayers[2].id]!

        // Continue with your point assignment logic here...
    
        if firstScore == secondScore && secondScore == thirdScore {
            // All players tied.
            for player in sortedPlayers {
                if let index = players.firstIndex(where: { $0.id == player.id }) {
                    players[index].total_score += 3
                }
            }
        } else if firstScore == secondScore {
            // First two players tied.
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[0].id }) {
                players[index].total_score += 4
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[1].id }) {
                players[index].total_score += 4
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[2].id }) {
                players[index].total_score += 1
            }
        } else if secondScore == thirdScore {
            // Last two players tied.
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[0].id }) {
                players[index].total_score += 5
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[1].id }) {
                players[index].total_score += 2
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[2].id }) {
                players[index].total_score += 2
            }
        } else {
            // No ties.
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[0].id }) {
                players[index].total_score += 5
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[1].id }) {
                players[index].total_score += 3
            }
            if let index = players.firstIndex(where: { $0.id == sortedPlayers[2].id }) {
                players[index].total_score += 1
            }
        }
        
        
    }
}
