//
//  Card.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/14/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class Card: NSObject {
    // Hola
    let name : String
    let value : Int
    let defValue = 1
    var visible = true
    
    init(cardName:String) {
        let index = cardName.startIndex
        let id = cardName.substring(to: cardName.index(after: index))
        switch id {
        case "A":
            name = "A"
            value = 1
        case "2":
            name = "2"
            value = 2
        case "3":
            name = "3"
            value = 3
        case "4":
            name = "4"
            value = 4
        case "5":
            name = "5"
            value = 5
        case "6":
            name = "6"
            value = 6
        case "7":
            name = "7"
            value = 7
        case "8":
            name = "8"
            value = 8
        case "9":
            name = "9"
            value = 9
        case "10":
            name = "10"
            value = 10
        case "K":
            name = "K"
            value = 10
        case "Q":
            name = "Q"
            value = 10
        case "J":
            name = "J"
            value = 10
        default:
            name = "Que?"
            value = 0
        }
    }
    
    init(cardName:String, cardValue:Int) {
        name = cardName
        value = cardValue
    }
    
    init(cardName:String, isVisible:Bool) {
        let index = cardName.startIndex
        let id = cardName.substring(to: cardName.index(after: index))
        switch id {
        case "A":
            name = "A"
            value = 11
        case "2":
            name = "2"
            value = 2
        case "3":
            name = "3"
            value = 3
        case "4":
            name = "4"
            value = 4
        case "5":
            name = "5"
            value = 5
        case "6":
            name = "6"
            value = 6
        case "7":
            name = "7"
            value = 7
        case "8":
            name = "8"
            value = 8
        case "9":
            name = "9"
            value = 9
        case "1":
            name = "10"
            value = 10
        case "K":
            name = "K"
            value = 10
        case "Q":
            name = "Q"
            value = 10
        case "J":
            name = "J"
            value = 10
        default:
            name = "Que?"
            value = 0
        }
        visible = isVisible
    }
    
    func switchVisibility(){
        visible = !visible
    }

}
