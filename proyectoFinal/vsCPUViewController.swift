//
//  vsCPUViewController.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/22/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit
import GameplayKit

class vsCPUViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var estado = State()
    var deck = [Card]()
    var discardPile = [Card]()
    let cardTypes = ["A","2","3","4","5","6","7","8","9","10","K","Q","J"]
    var aICanPlay = false
    @IBOutlet weak var playerHandPicker: UIPickerView!
    @IBOutlet weak var opponentHandPicker: UIPickerView!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDeck()
        for card in deck{
            print(card.name)
        }
        
        hitButton.isEnabled = false
        callButton.isEnabled = false
        
        playerHandPicker.dataSource = self
        playerHandPicker.delegate = self
        opponentHandPicker.dataSource = self
        opponentHandPicker.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Picker Data Source Methods
    /*func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
     return 1
     }*/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(playerHandPicker) {
            return estado.playerHand.count
        }
        else{
            return estado.opponentHand.count
        }
    }
    
    /*func pickerView(pickerView: UIPickerView,
     numberOfRowsInComponent component: Int) -> Int {
     if pickerView.isEqual(playerHandPicker) {
     return estado.playerHand.count
     }
     else{
     return estado.opponentHand.count
     }
     }*/
    
    // MARK: Picker Delegate Methods
    /*func pickerView(pickerView: UIPickerView,
     titleForRow row: Int,
     forComponent component: Int) -> String? {
     if pickerView.isEqual(playerHandPicker) {
     return estado.playerHand[row].name
     }
     else{
     return estado.opponentHand[row].name
     }
     }*/
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(playerHandPicker) {
            if !estado.playerHand[row].visible {
                return "?"
            }
            else{
                return estado.playerHand[row].name
            }
        }
        else{
            return estado.opponentHand[row].name
        }
    }
    
    //MARK: Game Functions
    func loadDeck() {
        for type in cardTypes{
            for _ in 1...4{
                var c = Card(cardName: type, isVisible: false)
                deck.append(c)
            }
        }
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: deck) as! [Card]
        estado.deckSize = deck.count
    }
    
    func reloadDeck() {
        print("Reloading Deck")
        for card in discardPile{
            deck.append(card)
        }
        deck = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: deck) as! [Card]
        estado.deckSize = deck.count
        estado.resetProbabilities()
        for card in estado.playerHand {
            estado.cardPlayed(card: card)
        }
        for card in estado.opponentHand{
            if card.visible {
                estado.cardPlayed(card: card)
            }
        }
        discardPile = [Card]()
    }
    
    func drawCard() -> Card {
        if estado.deckSize == 0 {
            reloadDeck()
        }
        var card = deck.popLast()!
        card.visible = true
        return card
    }
    
    func drawSecret() -> Card {
        if estado.deckSize == 0 {
            reloadDeck()
        }
        var card = deck.popLast()!
        card.visible = false
        return card
    }
    
    /*func getHandValue(hand:[Card]) -> Int {
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
    }*/
    
    func checkDefaultWinner() -> Bool {
        let playerValue = estado.getHandValue(hand: estado.playerHand)
        if playerValue == 21 {
            playerWins()
            return true
        }
        if playerValue > 21 {
            opponentWins()
            return true
        }
        let opponentValue = estado.getHandValue(hand: estado.opponentHand)
        if opponentValue == 21 {
            opponentWins()
            return true
        }
        if opponentValue > 21{
            playerWins()
            return true
        }
        return false
    }
    
    func playerWins() {
        hitButton.isEnabled = false
        callButton.isEnabled = false
        for card in estado.playerHand {
            card.visible = true
        }
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        let alertController = UIAlertController(title: "AIBlackJack", message:
            "CPU Wins!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func opponentWins() {
        hitButton.isEnabled = false
        callButton.isEnabled = false
        for card in estado.playerHand {
            card.visible = true
        }
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        let alertController = UIAlertController(title: "AIBlackJack", message:
            "You Win!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func firstHeuristic() -> Int {
        let playerValue = estado.getHandValue(hand: estado.playerHand)
        var newOpponentHand = [Card]()
        for card in estado.opponentHand{
            if card.visible {
                newOpponentHand.append(card)
            }
        }
        var index = 0
        var prob = 0.0
        estado.getProbabilities()
        for i in 0...9{
            let checkProb = estado.probabilityArray[i]
            if checkProb > prob{
                prob = checkProb
                index = i
            }
        }
        let newCard = Card(cardName: cardTypes[index], isVisible: true)
        newOpponentHand.append(newCard)
        let opponentValue = estado.getHandValue(hand: newOpponentHand)
        return playerValue - opponentValue
    }
    
    func secondHeuristic() -> Int {
        let playerValue = estado.getHandValue(hand: estado.playerHand)
        var newOpponentHand = [Card]()
        for card in estado.opponentHand{
            if card.visible {
                newOpponentHand.append(card)
            }
        }
        estado.getProbabilities()
        var opponentValue = 0.0
        for i in 0...9{
            let newCard = Card(cardName: cardTypes[i], isVisible: true)
            var tempOpHand = [Card]()
            tempOpHand.append(contentsOf: newOpponentHand)
            tempOpHand.append(newCard)
            let tempValue = estado.getHandValue(hand: tempOpHand)
            opponentValue += (Double(tempValue) * estado.probabilityArray[i])
        }
        return playerValue - Int(opponentValue)
    }
    
    func printHeuristics(){
        print("First:")
        print(firstHeuristic())
        print("Second:")
        print(secondHeuristic())
    }
    
    //MARK: Actions
    
    @IBAction func startGame(_ sender: UIButton) {
        estado.addToPlayerHand(card: drawCard())
        estado.addToOpponentHand(card: drawCard())
        estado.addToPlayerHand(card: drawSecret())
        estado.addToOpponentHand(card: drawSecret())
        startGameButton.isEnabled = false
        hitButton.isEnabled = !estado.turn
        callButton.isEnabled = !estado.turn
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        //printHeuristics()
        //minMax(state: estado)
        aICanPlay = estado.turn
        if aICanPlay {
            minMax(state: estado)
        }
    }
    
    @IBAction func hitPlayer(_ sender: UIButton) {
        estado.addToOpponentHand(card: drawCard())
        hitButton.isEnabled = false
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        if !checkDefaultWinner(){
            aICanPlay = true
            minMax(state: estado)
        }
    }
    
    func hitOpponent() {
        estado.addToPlayerHand(card: drawCard())
        hitButton.isEnabled = true
        callButton.isEnabled = true
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        if !checkDefaultWinner(){
            aICanPlay = false
        }
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        estado.resetProbabilities()
        for card in estado.playerHand{
            card.visible = true
            estado.cardPlayed(card: card)
            discardPile.append(card)
        }
        for card in estado.opponentHand{
            card.visible = true
            estado.cardPlayed(card: card)
            discardPile.append(card)
        }
        estado.playerHand = [Card]()
        estado.opponentHand = [Card]()
        estado.deckSize = deck.count
        hitButton.isEnabled = false
        callButton.isEnabled = false
        startGameButton.isEnabled = true
        aICanPlay = false
        playerHandPicker.reloadAllComponents()
        opponentHandPicker.reloadAllComponents()
        
    }
    
    @IBAction func call(_ sender: UIButton) {
        doCall()
    }
    
    func doCall() {
        let playerValue = estado.getHandValue(hand: estado.playerHand)
        let opponentValue = estado.getHandValue(hand: estado.opponentHand)
        if playerValue >= opponentValue {
            playerWins()
        }
        else{
            opponentWins()
        }
        aICanPlay = false
    }
    
    //MinMax Tree
    func minMax(state:State) {
        let depth = 2
        state.setChildrenNodes()
        for i in 0...1 {
            for n in state.children[i].children {
                if i == 0 {
                    n.setChildrenNodes()
                    for j in 0...1 {
                        for c in n.children[j].children {
                            c.setNodeValue()
                            print("D2, Value = \(c.minMaxValue)")
                        }
                        n.children[j].calculateValue()
                        print("P2, Value = \(n.children[j].value)")
                    }
                }
                n.setNodeValue()
                print("D1, Value = \(n.minMaxValue)")
            }
            state.children[i].calculateValue()
            print("P1, Value = \(state.children[i].value)")
        }
        state.setNodeValue()
        print("D0, Value = \(state.minMaxValue)")
        print("\(state.getHandValue(hand: state.playerHand))")
        if state.minMaxValue == state.children[1].value {
            doCall()
        }
        else{
            hitOpponent()
        }
        
    }

}
