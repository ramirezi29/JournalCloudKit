//
//  EntryController.swift
//  JournalCloudKit
//
//  Created by Ivan Ramirez on 9/24/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //shared instance/singleton
    static let shared = EntryController()
    
    //sourch of truth
    var entries: [Entry] = []
    
    
    //MARK: Save
    
    func save(entry: Entry, completion: @escaping (Bool) -> ()) {

        let EntryRecord = CKRecord(entry:entry)
        CKContainer.default().privateCloudDatabase.save(EntryRecord) { (record, error) in
            
            if let error = error {
                print("🚀 There was an eerror in \(#function); \(error); \(error.localizedDescription) 🚀")
                completion(false)
                return
            }
            guard let record = record, let entry = Entry(ckRecord: record) else {completion(false) ; return }
            self.entries.append(entry)
            completion(true)
        }
    }
    

    //MARK: Create
    
    func addEntryWith(title: String, textBody: String, completion: @escaping (Bool) -> Void){
        //Entry with memberwise initializers
        let entry = Entry(title: title, textBody: textBody)
        self.save(entry: entry) { (success) in
            if success {
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    func updateEntry(entry:Entry, title: String, textBody: String, completion: @escaping (Bool) -> Void){
        entry.title = title
        entry.textBody = textBody
    }
    
   // MARK: Fetch
    
    //fetch all the entries in your private dataBase
    func fetchEntries(completion: @escaping (Bool) ->()) {
        //2. create Predicate syntax:
        //true it will return everything. value -> The Boolean value to which the new predicate should evaluate.
        let predicate = NSPredicate(value: true)
        //1.create CKQuery: describes the criteria to apply to your records search
        //the recordType will be a the string representation of our CKRecord
        let querry = CKQuery(recordType: Constants.TypeKey, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(querry, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("🚀 There was an error in \(#function); \(error); \(error.localizedDescription) 🚀")
                completion(false)
                return
            }
            //unwrap your array of records
            guard let records = records else {completion (false) ; return}
           //Now that you have an array of CKRecords, you can loop through the array and attempt to initialize an Entry with them. We are able to do this because we created a the failable initializer in the Model that takes in a CKRecord
            let entries = records.compactMap {Entry(ckRecord: $0)}
            self.entries = entries
            completion(true)
            
        }
        
    }
}
