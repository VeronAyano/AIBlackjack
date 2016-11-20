//
//  ProbabilisticNode.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/18/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class ProbabilisticNode: NSObject {
    
    var children = [State]()
    var value = 0
    
    func setChildren(childrenStates:[State]) {
        children = childrenStates
        calculateValue()
    }
    
    func calculateValue() {
        var calculatedValue = 0.0
        for state in children {
            calculatedValue += state.prob * Double(state.minMaxValue)
        }
        value = Int(calculatedValue)
    }

}
