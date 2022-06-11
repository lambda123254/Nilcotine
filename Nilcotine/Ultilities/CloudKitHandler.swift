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
    
    public func get() async throws -> [CKRecord]{
        //Cara ambil data per key -->> records.compactMap({$0.value(forKey: "nama keynya") as? String})
        let query = CKQuery(recordType: recordString, predicate: NSPredicate(value: true))
        var dataReturn: [CKRecord] = []
        if let rec = try? await db.perform(query, inZoneWith: nil) {
            dataReturn = rec
        }
        return dataReturn
    }
}

