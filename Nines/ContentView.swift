//
//  ContentView.swift
//  Nines
//
//  Created by Matteo Mastandrea and Mohammad Alemi on 10/30/23.
//

import SwiftUI

// Defines a new structure called ContentView that conforms to the View protocol,
// which is required for all views in SwiftUI.
struct ContentView: View {
    
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Nines Logo Shadow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                
                NavigationLink(destination: AddPlayers(), isActive: $navigateToGame) {
                    Text("Start Round")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
        }
    }
    
}

struct AddPlayers: View {
    // State variable to store the current text in the text field
    @State private var currentPlayerName: String = ""
    
    // State variable to store the list of player names
    @State private var playerNames: [String] = []
    
    @State private var selectedHoles: String = "9 holes"
    
    @State private var navigateToPlay = false

    var body: some View {
        VStack(spacing: 20) {
            
            // Player Entry View
            HStack(spacing: 10) {
                TextField("Enter Player Name", text: $currentPlayerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if !currentPlayerName.isEmpty {
                        playerNames.append(currentPlayerName)
                        currentPlayerName = "" // Reset text field
                    }
                }) {
                    Text("Add Player")
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            // List of Players
            List {
                ForEach(playerNames, id: \.self) { playerName in
                    HStack {
                        Text(playerName)
                        Spacer()
                        Button(action: {
                            if let index = playerNames.firstIndex(of: playerName) {
                                playerNames.remove(at: index)
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            TwoSidedButton(selectedOption: $selectedHoles)
                        
            Spacer()
            
            NavigationLink(destination: PlayGame(playerNames: playerNames, selectedHoles: selectedHoles), isActive: $navigateToPlay) {
                Text("Start Round")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct TwoSidedButton: View {
    @Binding var selectedOption: String
    
    var body: some View {
        HStack {
            Button(action: {
                selectedOption = "9 holes"
            }) {
                Text("9 holes")
                    .padding()
                    .background(selectedOption == "9 holes" ? Color.blue : Color.gray)
                    .foregroundColor(selectedOption == "9 holes" ? .white : .black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                selectedOption = "18 holes"
            }) {
                Text("18 holes")
                    .padding()
                    .background(selectedOption == "18 holes" ? Color.blue : Color.gray)
                    .foregroundColor(selectedOption == "18 holes" ? .white : .black)
                    .cornerRadius(8)
            }
        }
    }
}

struct PlayGame: View {
    var playerNames: [String]
    var selectedHoles: String
    var holeCount: Int {
        return selectedHoles == "9 holes" ? 9 : 18
    }
    
    @State private var currentHole = 1
    @State private var holeScores: [[Int]] = Array(repeating: Array(repeating: 0, count: 18), count: 3)
    @State private var currentStrokes: [Int] = Array(repeating: 0, count: 3)

    var body: some View {
        VStack {
            // Scoreboard Section
            ScrollView([.horizontal, .vertical]) {
                VStack {
                    // Scoreboard Header
                    HStack {
                        Text("Player")
                            .frame(width: 80)
                        
                        ForEach(1...holeCount, id: \.self) { hole in
                            Text("Hole \(hole)")
                                .frame(width: 40)
                        }
                    }
                    .font(.headline)
                    
                    // Scoreboard Rows
                    ForEach(playerNames.indices, id: \.self) { index in
                        ScoreRow(playerName: playerNames[index], holeScores: $holeScores[index], holeCount: holeCount)
                    }
                }
                .padding()
            }
            
            // Separator
            Divider()
            
            
            // Input Section
            VStack {
                Text("Hole \(currentHole):")
                    .font(.headline)
                
                ForEach(playerNames.indices, id: \.self) { index in
                    HStack {
                        Text("\(playerNames[index]):")
                        TextField("Strokes", value: $currentStrokes[index], formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 60)
                    }
                }
                
                // Submit Hole Button
                Button("Submit Hole") {

                    for i in 0..<playerNames.count {
                        holeScores[i][currentHole - 1] = currentStrokes[i]
                    }
                    
                    
                    // Move to the next hole
                    if currentHole < holeCount {
                        currentHole += 1
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct ScoreRow: View {
    var playerName: String
    @Binding var holeScores: [Int]
    var holeCount: Int

    var body: some View {
        HStack {
            Text(playerName)
                .frame(width: 80)

            ForEach(0..<holeCount, id: \.self) { hole in
                Text("\(holeScores[hole])")
                    .frame(width: 40)
                    .padding(.horizontal, 5)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
