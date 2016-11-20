//
//  State.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/14/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class State: NSObject, NSCopying {
    
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
    var children = [ProbabilisticNode]()
    var minMaxValue = 0
    let heuristicTypeFirst = 0
    let heuristicTypeSecond = 1
    var hasChildren = false
    
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
        prob = 1.0
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
        var totalProb = 0.0
        for i in 0...9{
            if i == 9{ //Si se trata de cartas con valor de 10...
                maxCards = 16.0 //Se define que hay 16 en total en un Deck comun.
            }
            else{
                maxCards = 4.0 //De las demàs, hay 4 por deck.
            }
            let cardsPlayed = Double(numbersPlayed[i+1]) //Halla la cantidad de cartas de cada valor que no se han jugado...
            //print(cardsPlayed)
            //print(deckSize)
            probabilityArray[i] = (maxCards - cardsPlayed)/Double(deckSize + 1) //Y halla las probabilidades de sacar una carta de ese valor.
            totalProb += probabilityArray[i]
        }
        print(probabilityArray)
        print(totalProb)
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
    
    func getChildrenStates(baseState:State) -> [State] {
        var childStates = [State]()
        getProbabilities()
        for i in 0...9{
            let newState = baseState.copy() as! State
            newState.turn = !newState.turn
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
        /*newState = baseState.copy() as! State
        newState.call()
        childStates.append(newState)*/
        return childStates
    }
    
    func setChildrenNodes() {
        children = [ProbabilisticNode]()
        let callProbNode = ProbabilisticNode()
        let callState = self.copy() as! State
        callState.call()
        callProbNode.setChildren(childrenStates: [callState])
        let hitProbNode = ProbabilisticNode()
        hitProbNode.setChildren(childrenStates: getChildrenStates(baseState: self))
        children.append(hitProbNode)
        children.append(callProbNode)
        hasChildren = true
    }
    
    func getHandValue(hand:[Card]) -> Int {
        var aces = 0
        var value = 0
        for card in hand{
            if card.value == 1 {
                aces += 1
            }
            else{
                value += card.value
            }
        }
        if aces > 0 {
            for _ in 1...aces {
                if (value + 11) <= 21 {
                    value += 11
                }
                else{
                    value += 1
                }
            }
        }
        return value
    }
    
    func checkDefaultWinner(playHand:[Card], otherHand:[Card]) -> Int {
        let playerValue = getHandValue(hand: playHand)
        if playerValue == 21 {
            return 21
        }
        if playerValue > 21 {
            return -21
        }
        let opponentValue = getHandValue(hand: otherHand)
        if opponentValue == 21 {
            return -21
        }
        if opponentValue > 21{
            return 21
        }
        return 0
    }
    
    func checkDefaultWinner(playerValue:Int, opponentValue:Int) -> Int {
        if playerValue == 21 {
            return 21
        }
        if playerValue > 21 {
            return -21
        }
        if opponentValue == 21 {
            return -21
        }
        if opponentValue > 21{
            return 21
        }
        return 0
    }
    
    func firstHeuristic() -> Int {
        var newOpponentHand = [Card]()
        for card in opponentHand{
            if card.visible {
                newOpponentHand.append(card)
            }
        }
        var index = 0
        var prob = 0.0
        getProbabilities()
        for i in 0...9{
            let checkProb = probabilityArray[i]
            if checkProb > prob{
                prob = checkProb
                index = i
            }
        }
        let newCard = Card(cardName: cardTypes[index], isVisible: true)
        newOpponentHand.append(newCard)
        var retVal = checkDefaultWinner(playHand: playerHand, otherHand: newOpponentHand)
        if retVal == 0 {
            let playerValue = getHandValue(hand: playerHand)
            let opponentValue = getHandValue(hand: newOpponentHand)
            retVal = playerValue - opponentValue
        }
        return retVal
    }
    
    func secondHeuristic() -> Int {
        let playerValue = getHandValue(hand: playerHand)
        var newOpponentHand = [Card]()
        for card in opponentHand{
            if card.visible {
                newOpponentHand.append(card)
            }
        }
        getProbabilities()
        var opponentValue = 0.0
        for i in 0...9{
            let newCard = Card(cardName: cardTypes[i], isVisible: true)
            var tempOpHand = [Card]()
            tempOpHand.append(contentsOf: newOpponentHand)
            tempOpHand.append(newCard)
            let tempValue = getHandValue(hand: tempOpHand)
            opponentValue += (Double(tempValue) * probabilityArray[i])
        }
        var retValue = checkDefaultWinner(playerValue: playerValue, opponentValue: Int(opponentValue))
        if retValue == 0 {
            retValue = playerValue - Int(opponentValue)
        }
        return retValue
    }
    
    func resetProbabilities() {
        numbersPlayed = [0,0,0,0,0,0,0,0,0,0,0,0]
        probabilityArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    }
    
    func setHeuristicType(type:Int) {
        heuristic = type
    }
    
    func setNodeValue() {
        if hasChildren {
            if turn {
                var greatestValue = -21
                for probNode in children {
                    if greatestValue < probNode.value {
                        greatestValue = probNode.value
                    }
                }
                minMaxValue = greatestValue
            }
            else{
                var lowestValue = 21
                for probNode in children{
                    if lowestValue > probNode.value {
                        lowestValue = probNode.value
                    }
                }
                minMaxValue = lowestValue
                
            }
        }
        else{
            if heuristic == 0 {
                minMaxValue = firstHeuristic()
            }
            else{
                minMaxValue = secondHeuristic()
            }
        }
    }
    
    //MARK: NSCopying
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newCopy = State()
        newCopy.setDeckSize(size: self.deckSize)
        for card in self.playerHand {
            newCopy.addToPlayerHand(card: card.copy() as! Card)
        }
        for card in self.opponentHand {
            newCopy.addToOpponentHand(card: card.copy() as! Card)
        }
        return newCopy
    }
    
}
