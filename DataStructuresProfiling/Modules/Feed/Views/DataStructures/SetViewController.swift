//
//  SetViewController.swift
//  DataStructures
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

import UIKit
import CoreData

private enum SetVCRow: Int {
  case creation = 0,
  add1Object,
  add5Objects,
  add10Objects,
  remove1Object,
  remove5Objects,
  remove10Objects,
  lookup1Object,
  lookup10Objects
}

class SetViewController: DataStructuresViewController {

  //MARK: - Variables

  let setManipulator = SwiftSetManipulator()

  var creationTime: TimeInterval = 0
  var add1ObjectTime: TimeInterval = 0
  var add5ObjectsTime: TimeInterval = 0
  var add10ObjectsTime: TimeInterval = 0
  var remove1ObjectTime: TimeInterval = 0
  var remove5ObjectsTime: TimeInterval = 0
  var remove10ObjectsTime: TimeInterval = 0
  var lookup1ObjectTime: TimeInterval = 0
  var lookup10ObjectsTime: TimeInterval = 0

  //MARK: - Methods

  //MARK: View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    createAndTestButton.setTitle("Create Set and Test", for: UIControl.State())
    fetchData()
  }

  //MARK: Superclass creation/testing/saving overrides

  override func create(_ size: Int) {
    creationTime = setManipulator.setupWithObjectCount(size)
  }

  override func test() {
    if (setManipulator.setHasObjects()) {
      add1ObjectTime = setManipulator.add1Object()
      add5ObjectsTime = setManipulator.add5Objects()
      add10ObjectsTime = setManipulator.add10Objects()
      remove1ObjectTime = setManipulator.remove1Object()
      remove5ObjectsTime = setManipulator.remove5Objects()
      remove10ObjectsTime = setManipulator.remove10Objects()
      lookup1ObjectTime = setManipulator.lookup1Object()
      lookup10ObjectsTime = setManipulator.lookup10Objects()
    } else {
      print("Set is not set up yet!")
    }
  }
    
    override func save() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Set")
            request.predicate = predicate
            
            var data: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                data = try? self.parentContext.fetch(request)[0]
            }
            if data == nil { data = DataStructure(context: self.parentContext) }
            guard let updateData = data else { return }
            
            updateData.id = "Set"
            updateData.creationTime = self.creationTime
            updateData.add1EntryTime = self.add1ObjectTime
            updateData.add5EntriesTime = self.add5ObjectsTime
            updateData.add10EntriesTime = self.add10ObjectsTime
            updateData.remove1EntryTime = self.remove1ObjectTime
            updateData.remove5EntriesTime = self.remove5ObjectsTime
            updateData.remove10EntriesTime = self.remove10ObjectsTime
            updateData.lookup1EntryTime = self.lookup1ObjectTime
            updateData.lookup10EntriesTime = self.lookup10ObjectsTime
            try? self.parentContext.save()
        }
    }

  //MARK: Table View Override

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)

    switch (indexPath as NSIndexPath).row {
    case SetVCRow.creation.rawValue:
      cell.textLabel!.text = "Set Creation:"
      cell.detailTextLabel!.text = formattedTime(creationTime)
    case SetVCRow.add1Object.rawValue:
      cell.textLabel!.text = "Add 1 Object:"
      cell.detailTextLabel!.text = formattedTime(add1ObjectTime)
    case SetVCRow.add5Objects.rawValue:
      cell.textLabel!.text = "Add 5 Objects:"
      cell.detailTextLabel!.text = formattedTime(add5ObjectsTime)
    case SetVCRow.add10Objects.rawValue:
      cell.textLabel!.text = "Add 10 Objects:"
      cell.detailTextLabel!.text = formattedTime(add10ObjectsTime)
    case SetVCRow.remove1Object.rawValue:
      cell.textLabel!.text = "Remove 1 Object:"
      cell.detailTextLabel!.text = formattedTime(remove1ObjectTime)
    case SetVCRow.remove5Objects.rawValue:
      cell.textLabel!.text = "Remove 5 Objects:"
      cell.detailTextLabel!.text = formattedTime(remove5ObjectsTime)
    case SetVCRow.remove10Objects.rawValue:
      cell.textLabel!.text = "Remove 10 Objects:"
      cell.detailTextLabel!.text = formattedTime(remove10ObjectsTime)
    case SetVCRow.lookup1Object.rawValue:
      cell.textLabel!.text = "Lookup 1 Object:"
      cell.detailTextLabel!.text = formattedTime(lookup1ObjectTime)
    case SetVCRow.lookup10Objects.rawValue:
      cell.textLabel!.text = "Lookup 10 Objects:"
      cell.detailTextLabel!.text = formattedTime(lookup10ObjectsTime)
    default:
      print("Unhandled row! \((indexPath as NSIndexPath).row)")
    }

    return cell
  }
    
    //MARK: Fetch Data
    
    private func fetchData() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Set")
            request.predicate = predicate
            
            var dataFromDB: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                dataFromDB = try? self.parentContext.fetch(request)[0]
            }
            guard let data = dataFromDB else { return }
            
            self.creationTime = data.creationTime
            self.add1ObjectTime = data.add1EntryTime
            self.add5ObjectsTime = data.add5EntriesTime
            self.add10ObjectsTime = data.add10EntriesTime
            self.remove1ObjectTime = data.remove1EntryTime
            self.remove5ObjectsTime = data.remove5EntriesTime
            self.remove10ObjectsTime = data.remove10EntriesTime
            self.lookup1ObjectTime = data.lookup1EntryTime
            self.lookup10ObjectsTime = data.lookup10EntriesTime
            
            self.resultsTableView.reloadData()
        }
    }
}
