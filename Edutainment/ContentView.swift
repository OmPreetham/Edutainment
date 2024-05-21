//
//  ContentView.swift
//  Edutainment
//
//  Created by Om Preetham Bandi on 5/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTableRange = 2
    @State private var numberOfQuestions = [5, 10, 20]
    @State private var selectedQuestionCount = 5
    @State private var chooseOptions = true
    
    @State private var endGame = false
    
    @State private var valueOne = 0
    @State private var valueTwo = 0
    
    @State private var userAnswer: String = ""
    @State private var actualAnswer = 0
    
    @State private var score = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertStatus = false
    
    @State private var countQuestions = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                if !endGame {
                    if chooseOptions {
                        VStack(spacing: 20) {
                            Form {
                                Section(header: Text("Select Multiplication Table")) {
                                    Stepper(value: $selectedTableRange, in: 2...12) {
                                        Text("\(selectedTableRange)").font(.headline)
                                    }
                                }
                                
                                Section(header: Text("Number of Questions")) {
                                    Picker(selection: $selectedQuestionCount, label: Text("")) {
                                        ForEach(numberOfQuestions, id: \.self) { value in
                                            Text("\(value)").tag(value)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                            }
                            Button("Generate Questions") {
                                withAnimation {
                                    generateQuestion()
                                    chooseOptions = false
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .scrollContentBackground(.hidden)
                    } else {
                        VStack(spacing: 20) {
                            Text("Multiplication Tables from 2 to \(selectedTableRange)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.blue)
                            Text("\(valueOne) * \(valueTwo) = ?")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            TextField("Answer Question", text: $userAnswer)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .focused(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=$isFocused@*/FocusState<Bool>().projectedValue/*@END_MENU_TOKEN@*/)
                            
                            Button("Submit Answer") {
                                answerQuestion()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .keyboardType(.numberPad)
                        .onSubmit {
                            answerQuestion()
                        }
                    }
                } else {
                    VStack {
                        Text("Game Over!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("You've completed \(countQuestions) questions.")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Your final score is \(score).")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Button("New Game") {
                            withAnimation {
                                endGame = false
                                chooseOptions = true
                                countQuestions = 0
                                score = 0
                                selectedTableRange = 2
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("Edutainment")
            .alert(isPresented: $alertStatus) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .default(Text("Next Question"), action: {
                        withAnimation {
                            generateQuestion()
                        }
                    }),
                    secondaryButton: .cancel({
                        withAnimation {
                            endGame = true
                        }
                    })
                )
            }
        }
    }
    
    func generateQuestion() {
        if countQuestions >= selectedQuestionCount {
            endGame = true
            return
        }
        
        valueOne = Int.random(in: 2...selectedTableRange)
        valueTwo = Int.random(in: 1...10)
        countQuestions += 1
        userAnswer = ""
        alertStatus = false
        endGame = false
    }
    
    func answerQuestion() {
        actualAnswer = valueOne * valueTwo
        if let userAnswerInt = Int(userAnswer), userAnswerInt == actualAnswer {
            score += 1
            alertTitle = "Correct!"
            alertMessage = "Well done! \(valueOne) * \(valueTwo) = \(actualAnswer)"
        } else {
            alertTitle = "Incorrect!"
            alertMessage = "Oops! \(valueOne) * \(valueTwo) = \(actualAnswer)"
        }
        alertStatus = true
    }
}

#Preview {
    ContentView()
}
