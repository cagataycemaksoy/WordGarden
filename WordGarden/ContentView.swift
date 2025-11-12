//
//  ContentView.swift
//  WordGarden
//
//  Created by Cem Aksoy on 9.11.2025.
//

import SwiftUI

struct ContentView: View {
  private static let startTitle = "How Many Guesses to Uncover the Hidden Word?"
  private static let maxGuesses = 8
  private let noGuessTitle = "So Sorry, You're All Out Of Guesses."
  private let words = ["CAT", "COFFEE", "HAT", "OMNISCIENCE"]
  
  @State private var availableGuesses = maxGuesses
  @State private var guessedWords = 0
  @State private var missedWords = 0
  private var toGuess: Int {
    words.count - guessedWords - missedWords
  }
  
  @State private var letter = ""
  @State private var lettersGuessed = ""
  @State private var imageName = "flower8"
  @State private var gameTitle = startTitle
  @State private var correctGuesses = 0
  @State private var guessWordIndex = 0
  @State private var nextButtonHidden = true
  
  private var revealedWord: String {
    var var2 = ""
    for l in words[guessWordIndex] {
      var2 += lettersGuessed.contains(l) ? "\(l) " : "_ "
    }
    var2.removeLast()
    return var2
  }
  
  @FocusState private var focusedKeyboard: Bool
  
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
        
        Text(gameTitle)
          .font(.title2)
          .fontWeight(.medium)
          .minimumScaleFactor(0.5)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        
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
              .onSubmit {
                guard !letter.isEmpty && availableGuesses > 0 else {
                  return
                }
                updateValues()
                updateView()
              }
            
            Button("Guess!") {
              //TODO: Check the letter in the word
              updateValues()
              updateView()
            }
            .fontWeight(.medium)
            .buttonStyle(.bordered)
            .tint(.appColor1.opacity(0.9))
            .foregroundStyle(.orange)
            .disabled(letter.isEmpty || availableGuesses == 0)
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
  
  func updateValues() {
    if !lettersGuessed.contains(letter) {
      withAnimation {
        lettersGuessed += letter
        if !words[guessWordIndex].contains(letter) {
          availableGuesses -= 1
          imageName = "wilt\(availableGuesses)"
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){
            imageName = "flower\(availableGuesses)"
          }
        } else {
          correctGuesses += 1
        }
      }
    }
    focusedKeyboard = false
  }
  
  func updateView() {
    let win = correctGuesses == words[guessWordIndex].count
    let plural = lettersGuessed.count == 1 ? "" : "es"
    
    if win {
      gameTitle = "You Guessed It! It Took You \(lettersGuessed.count) Guess\(plural) to Guess the Word!"
    } else if availableGuesses == 0 {
      gameTitle = noGuessTitle
    } else {
      gameTitle = "You have made \(lettersGuessed.count) Guess\(plural)"
    }
    
    if availableGuesses == 0 || win {
      nextButtonHidden = false
    }
    
    letter = ""
  }
}

#Preview {
  ContentView()
}
