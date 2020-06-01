//
//  ArrayViewController.swift
//  DataStructures
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

private enum ArrayVCRow: Int {
    case creation = 0,
    insertAt0,
    insertAtMid,
    insertAtEnd,
    deleteAt0,
    deleteAtMid,
    deleteAtEnd,
    lookupByIndex,
    lookupByObject
}

import UIKit
import CoreData

class ArrayViewController: DataStructuresViewController {
    
    //MARK: - Variables
    
    let arrayManipulator: ArrayManipulator = SwiftArrayManipulator()
    
    var creationTime: TimeInterval = 0
    var insertAt0Time: TimeInterval = 0
    var insertAtMidTime: TimeInterval = 0
    var insertAtEndTime: TimeInterval = 0
    var removeAt0Time: TimeInterval = 0
    var removeAtMidTime: TimeInterval = 0
    var removeAtEndTime: TimeInterval = 0
    var lookupByIndexTime: TimeInterval = 0
    var lookupByObjectTime: TimeInterval = 0
    
    //MARK: - Methods
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndTestButton.setTitle("Create Array and Test", for: [])
        fetchData()
    }
    
    //MARK: Superclass creation/testing/saving overrides
    
    override func create(_ size: Int) {
        creationTime = arrayManipulator.setupWithObjectCount(size)
    }
    
    override func test() {
        if (arrayManipulator.arrayHasObjects()) {
            insertAt0Time = arrayManipulator.insertNewObjectAtBeginning()
            insertAtMidTime = arrayManipulator.insertNewObjectInMiddle()
            insertAtEndTime = arrayManipulator.addNewObjectAtEnd()
            removeAt0Time = arrayManipulator.removeFirstObject()
            removeAtMidTime = arrayManipulator.removeMiddleObject()
            removeAtEndTime = arrayManipulator.removeLastObject()
            lookupByIndexTime = arrayManipulator.lookupByIndex()
            lookupByObjectTime = arrayManipulator.lookupByObject()
        } else {
            print("Array not set up yet!")
        }
    }
    
    override func save() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Array")
            request.predicate = predicate
            
            var data: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                data = try? self.parentContext.fetch(request)[0]
            }
            if data == nil { data = DataStructure(context: self.parentContext) }
            guard let updateData = data else { return }
            
            updateData.id = "Array"
            updateData.creationTime = self.creationTime
            updateData.add1EntryTime = self.insertAt0Time
            updateData.add5EntriesTime = self.insertAtMidTime
            updateData.add10EntriesTime = self.insertAtEndTime
            updateData.remove1EntryTime = self.removeAt0Time
            updateData.remove5EntriesTime = self.removeAtMidTime
            updateData.remove10EntriesTime = self.removeAtEndTime
            updateData.lookup1EntryTime = self.lookupByIndexTime
            updateData.lookup10EntriesTime = self.lookupByObjectTime
            try? self.parentContext.save()
        }
    }
    
    //MARK: Table View Override
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch (indexPath as NSIndexPath).row {
        case ArrayVCRow.creation.rawValue:
            cell.textLabel!.text = "Array Creation:"
            cell.detailTextLabel!.text = formattedTime(creationTime)
        case ArrayVCRow.insertAt0.rawValue:
            cell.textLabel!.text = "Insert At Index 0:"
            cell.detailTextLabel!.text = formattedTime(insertAt0Time)
        case ArrayVCRow.insertAtMid.rawValue:
            cell.textLabel!.text = "Insert In Middle:"
            cell.detailTextLabel!.text = formattedTime(insertAtMidTime)
        case ArrayVCRow.insertAtEnd.rawValue:
            cell.textLabel!.text = "Insert At End:"
            cell.detailTextLabel!.text = formattedTime(insertAtEndTime)
        case ArrayVCRow.deleteAt0.rawValue:
            cell.textLabel!.text = "Remove From Index 0:"
            cell.detailTextLabel!.text = formattedTime(removeAt0Time)
        case ArrayVCRow.deleteAtMid.rawValue:
            cell.textLabel!.text = "Remove From Middle:"
            cell.detailTextLabel!.text = formattedTime(removeAtMidTime)
        case ArrayVCRow.deleteAtEnd.rawValue:
            cell.textLabel!.text = "Remove From End:"
            cell.detailTextLabel!.text = formattedTime(removeAtEndTime)
        case ArrayVCRow.lookupByIndex.rawValue:
            cell.textLabel!.text = "Lookup By Index:"
            cell.detailTextLabel!.text = formattedTime(lookupByIndexTime)
        case ArrayVCRow.lookupByObject.rawValue:
            cell.textLabel!.text = "Lookup By Object:"
            cell.detailTextLabel!.text = formattedTime(lookupByObjectTime)
        default:
            print("Unhandled row! \((indexPath as NSIndexPath).row)")
        }
        
        return cell
    }
    
    //MARK: Fetch Data
    
    private func fetchData() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Array")
            request.predicate = predicate
            
            var dataFromDB: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                dataFromDB = try? self.parentContext.fetch(request)[0]
            }
            guard let data = dataFromDB else { return }
            
            self.creationTime = data.creationTime
            self.insertAt0Time = data.add1EntryTime
            self.insertAtMidTime = data.add5EntriesTime
            self.insertAtEndTime = data.add10EntriesTime
            self.removeAt0Time = data.remove1EntryTime
            self.removeAtMidTime = data.remove5EntriesTime
            self.removeAtEndTime = data.remove10EntriesTime
            self.lookupByIndexTime = data.lookup1EntryTime
            self.lookupByObjectTime = data.lookup10EntriesTime
            
            self.resultsTableView.reloadData()
        }
    }
}
