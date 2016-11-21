//
//  Player.swift
//  proyectoFinal
//
//  Created by Eliezer Hernandez on 18/11/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import UIKit

class Player: NSObject , NSCoding  {
   /* var name: String = ""
    var lugar: String = ""
    var saludos: String = ""
   */
    var name: String
    var lugar: String
    var saludos: String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("players")
    
    
    struct PropertyKey{
    static let nameKey = "name"
    static let lugarKey = "lugar"
    static let saludosKey = "saludos"
        
    
        
        
    }
    
    init?(name: String, lugar: String, saludos: String) {
    self.name = name
    self.lugar = lugar
    self.saludos = saludos
        super.init()
        
        if name.isEmpty || lugar.isEmpty || saludos.isEmpty {
            return nil
        }

        
        
    }
    
    
   /* func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(lugar, forKey: PropertyKey.lugarKey)
        aCoder.encode(saludos, forKey: PropertyKey.saludosKey)
        
        
    } */
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(lugar, forKey: PropertyKey.lugarKey)
        aCoder.encode(saludos, forKey: PropertyKey.saludosKey)
        
    }
    
    
    required  convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let lugar = aDecoder.decodeObject(forKey: PropertyKey.lugarKey) as! String
        let saludos = aDecoder.decodeObject(forKey: PropertyKey.saludosKey) as! String
        
        self.init(name: name, lugar: lugar, saludos: saludos)
        
    }
    
    // MARK: Archiving Paths
    
    
    

}
