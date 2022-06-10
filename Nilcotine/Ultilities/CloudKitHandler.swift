//
//  CloudKitHandler.swift
//  Nilcotine
//
//  Created by Reza Mac on 10/06/22.
//

import Foundation
import CloudKit

public class CloudKitHandler {
    
    var dbString: String
    var recordString: String
    
    lazy var db = CKContainer(identifier: dbString).publicCloudDatabase
    lazy var record = CKRecord(recordType: recordString)

    init(dbString: String, recordString: String){
        self.dbString = dbString
        self.recordString = recordString
    }
    
    public func insert(value: String, key: String){
        record.setValue(value, forKey: key)
        db.save(record) { record, error in
            print(error ?? "saved")
        }
    }
    
    public func get(key: String){
        let query = CKQuery(recordType: recordString, predicate: NSPredicate(value: true))
        db.perform(query, inZoneWith: nil) { records, err in
            guard let records = records, err == nil else {
                return
            }
            print(records.compactMap({$0.value(forKey: key) as? String}))
        }
    }
}
