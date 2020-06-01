//
//  DataStructure+CoreDataProperties.swift
//  DataStructuresProfiling
//
//  Created by Pavel on 01.06.2020.
//  Copyright © 2020 Exey Panteleev. All rights reserved.
//
//

import Foundation
import CoreData


extension DataStructure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataStructure> {
        return NSFetchRequest<DataStructure>(entityName: "DataStructure")
    }

    @NSManaged public var creationTime: Double
    @NSManaged public var add1EntryTime: Double
    @NSManaged public var add5EntriesTime: Double
    @NSManaged public var add10EntriesTime: Double
    @NSManaged public var remove1EntryTime: Double
    @NSManaged public var remove5EntriesTime: Double
    @NSManaged public var remove10EntriesTime: Double
    @NSManaged public var lookup1EntryTime: Double
    @NSManaged public var lookup10EntriesTime: Double
    @NSManaged public var id: String?

}
