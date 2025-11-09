//
//  ContentView.swift
//  WordGarden
//
//  Created by Cem Aksoy on 9.11.2025.
//

import SwiftUI

struct ContentView: View {
  @State private var guessedWords = 0
  @State private var missedWords = 0
  @State private var letter = ""
  @State private var current = 0
  @State private var imageName = "flower8"
  @State private var nextButtonHidden = true
  
  private var toGuess: Int {
    words.count - guessedWords - missedWords
  }
  private var displayedWord: String {
    var gameWord = ""
    for _ in words[current] {
      gameWord += "_ "
    }
    return gameWord
  }
  
  private let words = ["CAT", "COFFEE", "HAT", "OMNISCIENCE"]
  
  var body: some View {
    GeometryReader { geo in
      VStack {
        HStack {
          VStack(alignment: .leading) {
            Text("Words guessed: \(guessedWords)")
            Text("Words missed: \(missedWords)")
          }
          Spacer()
          VStack(alignment: .trailing) {
            Text("Words to guess: \(toGuess)")
            Text("Words in game: \(words.count)")
          }
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .padding()
        
        RoundedRectangle(cornerRadius: 30)
          .fill(.black.opacity(0.3))
          .frame(height: 0.6)
          .padding(.horizontal)
        
        Text("How Many Guesses to Uncover the Hidden Word?")
          .font(.title2)
          .fontWeight(.medium)
          .multilineTextAlignment(.center)
        
        Text(displayedWord)
          .font(.title3)
          .fontWeight(.medium)
          .padding([.top, .horizontal])
        
        if nextButtonHidden {
          HStack{
            TextField("", text: $letter)
              .textFieldStyle(.roundedBorder)
              .frame(width: 37)
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black))
            
            Button("Guess!") {
              //TODO: Check the letter in the word
              withAnimation {
                nextButtonHidden.toggle()
              }
            }
            .fontWeight(.medium)
            .buttonStyle(.bordered)
            .tint(.appColor1.opacity(0.9))
            .foregroundStyle(.orange)
          }
          .padding(.bottom)
        } else {
          Button("New Word?") {
            //TODO: New game with a new word
            withAnimation {
              nextButtonHidden.toggle()
            }
          }
          .fontWeight(.medium)
          .buttonStyle(.borderedProminent)
          .tint(.appColor1)
          .foregroundStyle(.orange)
        }
        
        Spacer()
        
        Image(imageName)
          .resizable()
          .scaledToFit()
          .frame(height: geo.size.height * 0.7)
        
      }
      .ignoresSafeArea(edges: .bottom)
    }
  }
}

#Preview {
  ContentView()
}
