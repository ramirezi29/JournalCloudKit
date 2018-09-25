//
//  Entry.swift
//  JournalCloudKit
//
//  Created by Ivan Ramirez on 9/24/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    //access outside of the class
    static let TypeKey = "Entry"
    static let titleKey = "Title"
    static let textBodyKey = "TextBody"
}


class Entry {
    
    var title: String
    var textBody: String
    var ckRecordID: CKRecord.ID
    
    //MARK: Memberwise
    init(title: String, textBody: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.textBody = textBody
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        //subscript to text title and body
        guard let title = ckRecord[Constants.titleKey] as? String,
            let bodyText = ckRecord[Constants.textBodyKey] as? String else {return nil}
        
        self.init(title: title, textBody: bodyText, ckRecordID: ckRecord.recordID)
    }
}

//Add an extension on CKRecord that initializes an instance of CKRecord with your custom model object. Here is where you set the key-value pairs.

extension CKRecord {
    convenience init(entry: Entry) {
        //CKRec.Rtype: main typeKey  recordID:
        self.init(recordType: Constants.TypeKey, recordID: entry.ckRecordID)
        
        self.setValue(entry.title, forKey: Constants.titleKey)
        self.setValue(entry.textBody, forKey: Constants.textBodyKey)
        
    }
}
