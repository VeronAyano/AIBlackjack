//
//  State.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/14/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class State: NSObject {
    
    var playerHand = [Card]()
    var opponentHand = [Card]()
    var callFlag = false
    var deckSize = 0
    var numbersPlayed = [0,0,0,0,0,0,0,0,0,0,0,0] //Arreglo que guarda las cartas que han sido jugadas.
    var probabilityArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0] //Arreglo que guarda las probabilidades de sacar cartas con un valor particular.
    var heuristic = 0
    var turn = true
    var prob = 0.0
    let cardTypes = ["A","2","3","4","5","6","7","8","9","10","K","Q","J"]
    
    func addToPlayerHand(card:Card){
        playerHand.append(card)
        cardPlayed(card: card)
        deckDecrement()
    }

    func addToOpponentHand(card:Card){
        opponentHand.append(card)
        if card.visible {
            cardPlayed(card: card)
        }
        deckDecrement()
    }
    
    func call(){
        callFlag = true
        print("Call: ")
        print(callFlag)
    }
    
    func setDeckSize(size:Int){
        deckSize = size
        print("Deck Size: ")
        print(deckSize)
    }
    
    func cardPlayed(card:Card){
        numbersPlayed[card.value] += 1
        print(numbersPlayed)
    }
    
    func deckDecrement() {
        deckSize -= 1
        print("Deck Size: ")
        print(deckSize)
    }
    
    func getProbabilities() {
        var maxCards = 0.0
        for i in 0...9{
            if i == 9{ //Si se trata de cartas con valor de 10...
                maxCards = 16.0 //Se define que hay 16 en total en un Deck comun.
            }
            else{
                maxCards = 4.0 //De las demàs, hay 4 por deck.
            }
            let cardsPlayed = Double(numbersPlayed[i+1]) //Halla la cantidad de cartas de cada valor que no se han jugado...
            probabilityArray[i] = (maxCards - cardsPlayed)/Double(deckSize) //Y halla las probabilidades de sacar una carta de ese valor.
        }
        print(probabilityArray)
    }
    
    func reset(){
        partialReset()
        deckSize = 0
        numbersPlayed = [0,0,0,0,0,0,0,0,0,0]
        probabilityArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    }
    
    func partialReset() {
        playerHand = [Card]()
        opponentHand = [Card]()
        callFlag = false
        heuristic = 0
    }
    
    func getChildren(baseState:State) -> [State] {
        var newState = baseState.copy() as! State
        newState.turn = !newState.turn
        var childStates = [State]()
        getProbabilities()
        for i in 0...9{
            let newCard = Card(cardName: cardTypes[i], isVisible: true)
            if newState.turn {
                newState.playerHand = baseState.playerHand
                newState.addToPlayerHand(card: newCard)
            }
            else{
                newState.opponentHand = baseState.opponentHand
                newState.addToOpponentHand(card: newCard)
            }
            newState.prob = probabilityArray[i]
            childStates.append(newState)
        }
        newState = baseState.copy() as! State
        newState.call()
        childStates.append(newState)
        return childStates
    }
}
