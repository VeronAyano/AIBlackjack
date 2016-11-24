//
//  Player+CoreDataProperties.swift
//  proyectoFinal
//
//  Created by Vicente Reyes on 11/23/16.
//  Copyright © 2016 Vicente Reyes. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player");
    }

    @NSManaged public var name: String?
    @NSManaged public var greeting: String?
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double

}
