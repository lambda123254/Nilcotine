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
    lazy var container = CKContainer(identifier: dbString)
    lazy var record = CKRecord(recordType: recordString)


    init(dbString: String, recordString: String){
        self.dbString = dbString
        self.recordString = recordString
    }
    
    public func getUserID() async throws -> CKRecord.ID {
        var idName: CKRecord.ID?
            if let id = try? await container.userRecordID() {
                idName = id
            }
        return idName!
        
    }
    
    public func createProfile() async {
        record.setValue("user112034", forKey: "username")
        record.setValue(34, forKey: "age")
        try? await record.setValue(CKRecord.Reference(recordID: getUserID(), action: CKRecord.ReferenceAction.none), forKey: "accountNumber")
        
        DispatchQueue.main.async {
            self.db.save(self.record) { record, error in
                print(error ?? "saved")
            }
        }
        
    }
    
    public func insert(value: String, key: String){
        record.setValue(value, forKey: key)
        db.save(record) { record, error in
            print(error ?? "saved")
        }
        
    }
    
    public func insertMultiple(value: String, key: String){
        let valArr = value.split(separator: ",").map{ String($0) }
        let keyArr = key.split(separator: ",").map{ String($0) }
        var sortedVal = [Any]()
        for i in 0 ..< valArr.count {
            if valArr[i].description.isNumeric {
                if valArr[i].contains("."){
                    if let changeVal = Double(valArr[i]) {
                        sortedVal.append(changeVal)
                    }
                }
                else {
                    if let changeVal = Int(valArr[i]) {
                        sortedVal.append(changeVal)
                    }
                }
            }
            else {
                sortedVal.append(valArr[i])
            }
                    
        }
        for i in 0 ..< valArr.count {
            record.setValue(sortedVal[i], forKey: keyArr[i])
        }
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
    
    public func update(recordName: String, key: String, value: String) {
        let recordID = CKRecord.ID(recordName: recordName)
        
        db.fetch(withRecordID: recordID) { record, error in
            if error == nil {
                record?.setValue(value, forKey: key)
                
                self.db.save(record!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("Record Saved")
                    } else {
                        print(error!)
                        print("Record Not Saved")
                    }
                })
            }
            else {
                print(error!)
                print("Could not fetch record")
                
            }
        }
    }
}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}
