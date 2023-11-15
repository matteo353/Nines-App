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
                            .background(Color(red: 0.145, green: 0.376, blue: 0.325))
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
    
    @State private var showAlert = false // State to control alert visibility


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
                            .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // List of Players
                List {
                    ForEach(players) { player in
                        HStack {
                            Text(player.name)
                            .foregroundColor(.white)
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
                        .fill(Color(red: 0.145, green: 0.376, blue: 0.325))) // Fill with the bubble color
                        .padding(.vertical, 8) // Add vertical space between list elements
                        .listRowInsets(EdgeInsets()) // Remove default list row padding
                        .listRowSeparator(.hidden)
                        
                    }
                    
                }
                .listStyle(PlainListStyle()) // Removes extra padding and separators
                .background(Color(red: 0.994, green: 0.993, blue: 0.941)) // Sets the background color of the entire list
                
                
                TwoSidedButton(selectedOption: $selectedHoles)
                
                Spacer()
                
                Button(action: {
                                    if players.count == 3 {
                                        navigateToPlay = true
                                    } else {
                                        showAlert = true // Show alert if there are not exactly 3 players
                                    }
                                }) {
                                    Text("Start Round")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(players.count == 3 ? Color(red: 0.145, green: 0.376, blue: 0.325) : Color.gray)
                                        .cornerRadius(8)
                                }
                                .disabled(players.count != 3) // Disable the button if there aren't exactly 3 players
                                .alert(isPresented: $showAlert) { // Alert for incorrect number of players
                                    Alert(
                                        title: Text("Invalid Player Count"),
                                        message: Text("The game must be played with exactly 3 players."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                
                
                NavigationLink(destination: PlayGame(viewModel: GameViewModel(players: players, selectedHoles: selectedHoles)), isActive: $navigateToPlay) {
                                    EmptyView()
                                }
                                .hidden() // Hide the navigation link

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
                    .background(selectedOption == "9 holes" ? Color(red: 0.145, green: 0.376, blue: 0.325) : Color.gray)
                    .foregroundColor(selectedOption == "9 holes" ? .white : .black)
                    .cornerRadius(8)
            }
            
            Button(action: {
                selectedOption = "18 holes"
            }) {
                Text("18 holes")
                    .padding()
                    .background(selectedOption == "18 holes" ? Color(red: 0.145, green: 0.376, blue: 0.325) : Color.gray)
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
                        .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                
                Image("Nines logo 3")
                    .resizable()
                    .scaledToFit()
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
                        .padding(.horizontal, 20) // Additional padding to provide whitespace around the element
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.145, green: 0.376, blue: 0.325)) // Apply the background to the HStack
                .edgesIgnoringSafeArea(.all)
                
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
                        .background(Color(red: 0.039, green: 0.153, blue: 0.239))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    }
                }
                
                
                // New Scorecard Section
                Spacer(minLength: 20) // Adds space
                
                
                HStack{
                    // Strokes on Current Hole title, aligned to the left
                    Text("Hole \(viewModel.currentHole)")
                        .font(.system(size: 34, weight: .bold, design: .rounded)) // Trendy and rounded font
                        .foregroundColor(.white)
                        .padding(.vertical, 10) // Adds some vertical padding
                        .padding(.horizontal, 20) // Adds horizontal padding to make it look like a tag
                        .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                        .cornerRadius(15) // Rounded corners
                        .padding(.horizontal, 20) // Additional padding to provide whitespace
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.145, green: 0.376, blue: 0.325)) // Apply the background to the HStack
                .edgesIgnoringSafeArea(.all)

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
                .background(Color(red: 0.145, green: 0.376, blue: 0.325))
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
            VStack {
                Image("Nines logo 3")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.75)
                
                Spacer(minLength: 20)
                
                HStack {
                    Text("Scorecard")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                        .cornerRadius(15)
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                .edgesIgnoringSafeArea(.all)
                
                Spacer(minLength: 25)
                
                ScrollView([.horizontal], showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 0) {
                            Text("Player")
                                .frame(width: 80)
                                .padding(.leading, 20)
                            ForEach(1...viewModel.holeScores[0].count, id: \.self) { holeNumber in
                                Text("\(holeNumber)")
                                    .frame(width: 40)
                                    .background(viewModel.currentHole == holeNumber ? Color(red: 0.051, green: 0.758, blue: 0.547) : Color.clear)
                                    .cornerRadius(5)
                            }
                            Text("Total")
                                .frame(width: 60)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color(red: 0.145, green: 0.376, blue: 0.325))
                        .cornerRadius(10)
                        .padding(.trailing, 20)
                        
                        ForEach(viewModel.players, id: \.id) { player in
                            HStack(spacing: 0) {
                                Text(player.name)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(width: 80)
                                    .padding(.leading, 20)
                                    .bold()
                                ForEach(viewModel.holeScores[viewModel.players.firstIndex(where: { $0.id == player.id }) ?? 0], id: \.self) { score in
                                    Text("\(score)")
                                        .frame(width: 40)
                                }
                                Text("\(player.total_strokes)")
                                    .frame(width: 60)
                            }
                            .frame(height: 44)
                            .background(Color(red: 0.039, green: 0.153, blue: 0.239))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer(minLength: 200)
            }
        }
    }
}
// View Modifier that makes sure that even with a long name, the
struct TruncateModifier: ViewModifier {
    var maxLength: Int

    func body(content: Content) -> some View {
        content
            .overlay(
                Text(String(repeating: " ", count: maxLength))
                    .font(.body)
                    .lineLimit(1)
                    .hidden()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
