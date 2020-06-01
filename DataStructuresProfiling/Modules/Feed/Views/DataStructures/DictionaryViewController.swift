//
//  DictionaryViewController.swift
//  DataStructures
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

import UIKit
import CoreData

private enum DictionaryVCRow: Int {
  case creation = 0,
  add1Entry,
  add5Entries,
  add10Entries,
  remove1Entry,
  remove5Entries,
  remove10Entries,
  lookup1Entry,
  lookup10Entries
}

class DictionaryViewController: DataStructuresViewController {

  //MARK: - Variables

  let dictionaryManipulator: DictionaryManipulator = SwiftDictionaryManipulator()

  var creationTime: TimeInterval = 0
  var add1EntryTime: TimeInterval = 0
  var add5EntriesTime: TimeInterval = 0
  var add10EntriesTime: TimeInterval = 0
  var remove1EntryTime: TimeInterval = 0
  var remove5EntriesTime: TimeInterval = 0
  var remove10EntriesTime: TimeInterval = 0
  var lookup1EntryTime: TimeInterval = 0
  var lookup10EntriesTime: TimeInterval = 0

  //MARK: - Methods

  //MARK: View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    createAndTestButton.setTitle("Create Dictionary and Test", for: UIControl.State())
    fetchData()
  }

  //MARK: Superclass creation/testing/saving overrides

  override func create(_ size: Int) {
    creationTime = dictionaryManipulator.setupWithEntryCount(size)
  }

  override func test() {
    if dictionaryManipulator.dictHasEntries() {
      add1EntryTime = dictionaryManipulator.add1Entry()
      add5EntriesTime = dictionaryManipulator.add5Entries()
      add10EntriesTime = dictionaryManipulator.add10Entries()
      remove1EntryTime = dictionaryManipulator.remove1Entry()
      remove5EntriesTime = dictionaryManipulator.remove5Entries()
      remove10EntriesTime = dictionaryManipulator.remove10Entries()
      lookup1EntryTime = dictionaryManipulator.lookup1EntryTime()
      lookup10EntriesTime = dictionaryManipulator.lookup10EntriesTime()
    } else {
      print("Dictionary not yet set up!")
    }
  }
    
    override func save() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Dictionary")
            request.predicate = predicate
            
            var data: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                data = try? self.parentContext.fetch(request)[0]
            }
            if data == nil { data = DataStructure(context: self.parentContext) }
            guard let updateData = data else { return }
            
            updateData.id = "Dictionary"
            updateData.creationTime = self.creationTime
            updateData.add1EntryTime = self.add1EntryTime
            updateData.add5EntriesTime = self.add5EntriesTime
            updateData.add10EntriesTime = self.add10EntriesTime
            updateData.remove1EntryTime = self.remove1EntryTime
            updateData.remove5EntriesTime = self.remove5EntriesTime
            updateData.remove10EntriesTime = self.remove10EntriesTime
            updateData.lookup1EntryTime = self.lookup1EntryTime
            updateData.lookup10EntriesTime = self.lookup10EntriesTime
            try? self.parentContext.save()
        }
    }

  //MARK: Table View Override

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)

    switch (indexPath as NSIndexPath).row {
    case DictionaryVCRow.creation.rawValue:
      cell.textLabel!.text = "Dictionary Creation:"
      cell.detailTextLabel!.text = formattedTime(creationTime)
    case DictionaryVCRow.add1Entry.rawValue:
      cell.textLabel!.text = "Add 1 Entry:"
      cell.detailTextLabel!.text = formattedTime(add1EntryTime)
    case DictionaryVCRow.add5Entries.rawValue:
      cell.textLabel!.text = "Add 5 Entries:"
      cell.detailTextLabel!.text = formattedTime(add5EntriesTime)
    case DictionaryVCRow.add10Entries.rawValue:
      cell.textLabel!.text = "Add 10 Entries:"
      cell.detailTextLabel!.text = formattedTime(add10EntriesTime)
    case DictionaryVCRow.remove1Entry.rawValue:
      cell.textLabel!.text = "Remove 1 Entry:"
      cell.detailTextLabel!.text = formattedTime(remove1EntryTime)
    case DictionaryVCRow.remove5Entries.rawValue:
      cell.textLabel!.text = "Remove 5 Entries:"
      cell.detailTextLabel!.text = formattedTime(remove5EntriesTime)
    case DictionaryVCRow.remove10Entries.rawValue:
      cell.textLabel!.text = "Remove 10 Entries:"
      cell.detailTextLabel!.text = formattedTime(remove10EntriesTime)
    case DictionaryVCRow.lookup1Entry.rawValue:
      cell.textLabel!.text = "Lookup 1 Entry:"
      cell.detailTextLabel!.text = formattedTime(lookup1EntryTime)
    case DictionaryVCRow.lookup10Entries.rawValue:
      cell.textLabel!.text = "Lookup 10 Entries:"
      cell.detailTextLabel!.text = formattedTime(lookup10EntriesTime)
    default:
      print("Unhandled row! \((indexPath as NSIndexPath).row)")
    }

    return cell
  }
    
    //MARK: Fetch Data
    
    private func fetchData() {
        parentContext.performAndWait {
            let request: NSFetchRequest = DataStructure.fetchRequest()
            let predicate = NSPredicate(format: "id = %@", "Dictionary")
            request.predicate = predicate
            
            var dataFromDB: DataStructure? = nil
            if (try? self.parentContext.fetch(request))?.count ?? 0 > 0 {
                dataFromDB = try? self.parentContext.fetch(request)[0]
            }
            guard let data = dataFromDB else { return }
            
            self.creationTime = data.creationTime
            self.add1EntryTime = data.add1EntryTime
            self.add5EntriesTime = data.add5EntriesTime
            self.add10EntriesTime = data.add10EntriesTime
            self.remove1EntryTime = data.remove1EntryTime
            self.remove5EntriesTime = data.remove5EntriesTime
            self.remove10EntriesTime = data.remove10EntriesTime
            self.lookup1EntryTime = data.lookup1EntryTime
            self.lookup10EntriesTime = data.lookup10EntriesTime
            
            self.resultsTableView.reloadData()
        }
    }
}
