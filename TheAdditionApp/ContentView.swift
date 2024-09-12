//
//  ContentView.swift
//  TheAdditionApp
//
//  Created by GuitarLearnerJas on 12/9/2024.
//

import SwiftUI
import AVFAudio
struct ContentView: View {
    
    @State private var firstNumber: Int = 0
    @State private var secondNumber: Int = 0
    @State private var emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐭", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌎", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var message = ""
    @State private var audioPlayer : AVAudioPlayer!
    @FocusState private var isOnFocus: Bool
    //check the disable status
    @State private var textFieldDisabled: Bool = false
    @State private var buttonDisabled: Bool = false
    @State private var playAgainButtonShown: Bool = false
    
    var body: some View {
        VStack {
            //Emoji Area
            Text("\(firstNumberEmojis) + \(secondNumberEmojis)")
                .font(.system(size: 80))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .animation(.smooth(duration: 0.8), value: firstNumber)
            
            Spacer()
            
            //Equation
            Text("\(firstNumber) + \(secondNumber) = ")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            TextField("Type your answer here", text: $answer)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(.gray, lineWidth: 2)
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .keyboardType(.numberPad)
                .focused($isOnFocus)
                .disabled(textFieldDisabled)
            
            //Button
            Button("That's my Answer!") {
                isOnFocus = false
                textFieldDisabled = true
                playAgainButtonShown = true
                if Int(answer) == firstNumber + secondNumber {
                    //if correct
                    playSound(soundname: "correct")
                   
                    message = "Correct!"
                } else {
                    // if wrong
                    playSound(soundname: "wrong")
                    
                    message = "Sorry the correct answer should be \(firstNumber+secondNumber)"
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty||textFieldDisabled)
            
            Spacer()
            Text("\(message)")
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .frame(height:120)
                .minimumScaleFactor(0.5)
                .foregroundColor(message == "Correct!" ? .green: .red)
            
            //Play again button   ---hide when button not pressed---
            if playAgainButtonShown {
                Button("Play Again?") {
                    resetGame()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("")
            }
        }
        .padding()
        .onAppear() {
            //Set the 2 numbers to random value 1...10
            resetGame()
        }
    }
    
    //Function section
    func setupEmojiString(number: Int) -> String {
        String(repeating: emojis[Int.random(in: 0...emojis.count-1)], count: number)
    }
    func playSound(soundname: String) {
        guard let soundFile = NSDataAsset(name: soundname)
        else {
            print("ERROR: cannot read sound file")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) playing audioPlayer")
            return
        }
    }
    func resetGame() {
        answer = ""
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = setupEmojiString(number: firstNumber)
        secondNumberEmojis = setupEmojiString(number: secondNumber)
        textFieldDisabled = false
        playAgainButtonShown = false
    }
}

#Preview {
    ContentView()
}
