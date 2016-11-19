//
//  Player.swift
//  proyectoFinal
//
//  Created by Eliezer Hernandez on 18/11/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name: String = ""
    var lugar: String = ""
    var saludos: String = ""
    
    struct PropertyKey{
    static let nameKey = "name"
    static let lugarKey = "lugar"
    static let saludosKey = "saludos"
        
    }
    init?(name: String, lugar: String, saludos: String) {
    self.name = name
    self.lugar = lugar
    self.saludos = saludos
    }
    
    
    
    

}
