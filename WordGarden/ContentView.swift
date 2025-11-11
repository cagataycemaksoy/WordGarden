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
  private var toGuess: Int {
    words.count - guessedWords - missedWords
  }
  
  @State private var letter = ""
  @State private var wordToGuess = 0
  @State private var lettersGuessed = ""
  private var revealedWord: String {
    var var2 = ""
    for l in words[wordToGuess] {
      var2 += lettersGuessed.contains(l) ? "\(l) " : "_ "
    }
    var2.removeLast()
    return var2
  }
  
  @State private var imageName = "flower8"
  @State private var nextButtonHidden = true
  @FocusState private var focusedKeyboard: Bool
  
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
        
        Text(revealedWord)
          .font(.title3)
          .fontWeight(.medium)
          .padding([.top, .horizontal])
        
        if nextButtonHidden {
          HStack{
            TextField("", text: $letter)
              .keyboardType(.asciiCapable)
              .submitLabel(.done)
              .textInputAutocapitalization(.characters)
              .autocorrectionDisabled()
              .textFieldStyle(.roundedBorder)
              .frame(width: 37)
              .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black))
              .onChange(of: letter) {
                letter = letter.trimmingCharacters(in: .letters.inverted)
                guard let lastChar = letter.last else {
                  return
                }
                letter = String(lastChar).uppercased()
              }
              .focused($focusedKeyboard)
            
            Button("Guess!") {
              //TODO: Check the letter in the word
              pressGuess()
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
  
  func pressGuess() {
    if !lettersGuessed.contains(letter) {
      withAnimation {
        lettersGuessed += letter
      }
    }
    letter = ""
    focusedKeyboard = false
  }
}

#Preview {
  ContentView()
}
