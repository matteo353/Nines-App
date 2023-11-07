//
//  ContentView.swift
//  Nines
//
//  Created by Matteo Mastandrea on 10/30/23.
//

import SwiftUI

// Defines a new structure called ContentView that conforms to the View protocol,
// which is required for all views in SwiftUI.
struct ContentView: View {
    
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.994, green: 0.993, blue: 0.941)
                                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Image("Nines logo 3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    
                    NavigationLink(destination: AddPlayers(), isActive: $navigateToGame) {
                        Text("Start Round")
                            .padding()
                            .background(Color(red: 0.051, green: 0.758, blue: 0.547))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
            }
        }
        .accentColor(Color(red: 0.039, green: 0.153, blue: 0.239))
    }
        
}

struct AddPlayers: View {
    // State variable to store the current text in the text field
    @State private var currentPlayerName: String = ""
    
    // State variable to store the list of player names
    @State private var players: [Player] = []
    
    @State private var selectedHoles: String = "9 holes"
    
    @State private var navigateToPlay = false

    var body: some View {
        ZStack {
            Color(red: 0.994, green: 0.993, blue: 0.941)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                Image("Nines logo 3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                
                // Player Entry View
                HStack(spacing: 10) {
                    TextField("Enter Player Name", text: $currentPlayerName)
                        .padding(12) // Adds padding inside the TextField
                        .background(Color(red: 0.98, green: 0.975, blue: 0.95)) // Light cream color background
                        .cornerRadius(5) // Rounded corners
                        .shadow(radius: 1) // Subtle shadow
                        .padding(.horizontal) // Padding to the outside of the TextField
                        .foregroundColor(Color(red: 0.0392, green: 0.1176, blue: 0.2392))
                    
                    Button(action: {
                        if !currentPlayerName.isEmpty {
                            let newPlayer = Player(name: currentPlayerName, current_score: 0, total_score: 0, total_strokes: 0)
                            players.append(newPlayer)
                            currentPlayerName = ""
                        }
                    }) {
                        Text("Add Player")
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color(red: 0.051, green: 0.758, blue: 0.547))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // List of Players
                List {
                    ForEach(players) { player in
                        HStack {
                            Text(player.name)
                            Spacer()
                            Button(action: {
                                if let index = players.firstIndex(where: { $0.id == player.id }) {
                                    players.remove(at: index)
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color(red:0.039, green:0.153, blue:0.239))
                            }
                            
                        }
                        .padding() // Add padding inside the HStack
                        .background(RoundedRectangle(cornerRadius: 10) // Use RoundedRectangle for corner radius
                        .fill(Color(red: 0.051, green: 0.758, blue: 0.547))) // Fill with the bubble color
                        .padding(.vertical, 8) // Add vertical space between list elements
                        .listRowInsets(EdgeInsets()) // Remove default list row padding
                        .listRowSeparator(.hidden)
                        
                    }
                    
                }
                .listStyle(PlainListStyle()) // Removes extra padding and separators
                .background(Color(red: 0.994, green: 0.993, blue: 0.941)) // Sets the background color of the entire list
                
                
                TwoSidedButton(selectedOption: $selectedHoles)
                
                Spacer()
                
                NavigationLink(destination: PlayGame(viewModel: GameViewModel(players: players, selectedHoles: selectedHoles)), isActive: $navigateToPlay) {
                    Text("Start Round")
                    
                        .padding()
                        .background(Color(red: 0.051, green: 0.758, blue: 0.547))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
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
                    .background(selectedOption == "9 holes" ? Color(red: 0.051, green: 0.758, blue: 0.547) : Color.gray)
                    .foregroundColor(selectedOption == "9 holes" ? .white : .black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                selectedOption = "18 holes"
            }) {
                Text("18 holes")
                    .padding()
                    .background(selectedOption == "18 holes" ? Color(red: 0.051, green: 0.758, blue: 0.547) : Color.gray)
                    .foregroundColor(selectedOption == "18 holes" ? .white : .black)
                    .cornerRadius(8)
            }
        }
    }
}

struct PlayGame: View {
    // Temporary storage for the scores input by the user for each player.
    @State private var inputScores: [UUID: Int] = [:]
    
    @State private var currentHole: Int = 0
    
    // An instance of the GameViewModel which contains the logic for updating scores.
    @ObservedObject var viewModel: GameViewModel
    
    @State private var navigateToScore = false
    
    
    var body: some View {
        ZStack {
            Color(red: 0.994, green: 0.993, blue: 0.941)
                .edgesIgnoringSafeArea(.all)
            VStack {
                NavigationLink(destination: viewScorecard(viewModel: viewModel), isActive: $navigateToScore) {
                    
                    Text("View Scorecard")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(Color(red: 0.051, green: 0.758, blue: 0.547)) // Use your app's theme color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                
                Image("Nines logo 3")
                    .resizable()
                    .scaledToFit() // or .scaledToFill() based on your preference
                    .scaleEffect(1.1)
                
                Spacer(minLength: 20) // Adds a bit of space before the title
                
                
                // Leaderboard title, now centered with an emoji
                HStack {
                    Spacer()
                    Text("Leaderboard")
                        .font(.system(size: 34, weight: .bold, design: .rounded)) // Trendy and rounded font
                        .foregroundColor(.white)
                        .padding(.vertical, 10) // Adds some vertical padding
                        .padding(.horizontal, 20) // Adds horizontal padding to make it look like a tag
                        .background(Color(red: 0.145, green: 0.376, blue: 0.325)) // Subtle gradient
                        .cornerRadius(15) // Rounded corners
                        .shadow(radius: 5) // Soft shadow for depth
                        .padding(.horizontal, 20) // Additional padding to provide whitespace around the element
                    Spacer()
                }
                
                Spacer(minLength: 10)
                
                // A custom list-like view for displaying the leaderboard
                VStack(spacing: 2) {
                    ForEach(viewModel.players.sorted(by: { $0.total_score > $1.total_score })) { player in
                        HStack {
                            Text(player.name)
                                .padding(.leading)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .bold()
                            Spacer()
                            Text("\(player.total_score)")
                                .padding(.trailing)
                        }
                        .frame(height: 44)
                        .background(Color(red: 0.039, green: 0.153, blue: 0.239)) // Change this to your preferred background color
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    }
                }
                
                
                // New Scorecard Section
                Spacer(minLength: 20) // Adds space
                
                
                
                // Strokes on Current Hole title, aligned to the left
                Text("Hole \(viewModel.currentHole)")
                    .font(.system(size: 34, weight: .bold, design: .rounded)) // Trendy and rounded font
                    .foregroundColor(.white)
                    .padding(.vertical, 10) // Adds some vertical padding
                    .padding(.horizontal, 20) // Adds horizontal padding to make it look like a tag
                    .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                    .cornerRadius(15) // Rounded corners
                    .shadow(radius: 5) // Soft shadow for depth
                    .padding(.horizontal, 20) // Additional padding to provide whitespace
                
                Spacer(minLength: 10)
                
                
                
                // A custom list-like view for inputting scores for the current hole.
                VStack(spacing: 2) {
                    ForEach(viewModel.players) { player in
                        HStack {
                            Text(player.name)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading) // Use frame to push the text field to the edge
                                .padding(.leading)
                                .bold()
                            
                            
                            TextField("Hole Score", value: Binding(
                                get: { self.inputScores[player.id, default: 0] },
                                set: { self.inputScores[player.id] = $0 }
                            ), formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 50) // Set the frame width of the TextField to keep it constant
                            .padding(.trailing)
                            .foregroundColor(Color(red: 0.04, green: 0.119, blue: 0.24))
                        }
                        .frame(height: 44)
                        .background(Color(red: 0.039, green: 0.153, blue: 0.239)) // Change this to your preferred background color
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    }
                }
                
                Spacer(minLength: 20) // Adds space before the button
                
                Button("Update Scores") {
                    viewModel.updateScores(with: inputScores)
                    viewModel.updateCard(with: inputScores)
                    inputScores.removeAll() // Reset the input scores
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.051, green: 0.758, blue: 0.547)) // Change this to your preferred button color
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer() // Pushes everything up
            }
        }
    }
    
}

struct viewScorecard: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        ZStack {
            Color(red: 0.994, green: 0.993, blue: 0.941)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Scorecard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Headers
                ScrollView([.horizontal]){
                    HStack {
                        Text("   ")
                            .frame(width: 45)
                        ForEach(1...viewModel.holeScores[0].count, id: \.self) { i in
                            Text("\(i)")
                                .frame(width: 20)
                        }
                        Text("Total")
                            .frame(width: 41)
                    }
                    .background(Color.gray.opacity(0.2))
                    
                    // Score Rows
                    ForEach(viewModel.players, id: \.id) { player in
                        HStack {
                            Text(player.name)
                                .frame(width: 45)
                            if let playerIndex = viewModel.players.firstIndex(where: { $0.id == player.id }) {
                                ForEach(viewModel.holeScores[playerIndex], id: \.self) { score in
                                    Text("\(score)")
                                        .frame(width: 20)
                                }
                            }
                            Text("\(player.total_strokes)")
                                .frame(width: 40)
                        }
                        .border(Color(red: 0.04, green: 0.119, blue: 0.24))
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
