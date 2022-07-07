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
    var userId: CKRecord.ID?

    lazy var db = CKContainer(identifier: dbString).publicCloudDatabase
    lazy var container = CKContainer(identifier: dbString)
    lazy var record = CKRecord(recordType: recordString)


    init(dbString: String, recordString: String){
        self.dbString = dbString
        self.recordString = recordString
        
        Task {
            self.userId = try await getUserID()
        }
    }
    
    public func getUserID() async throws -> CKRecord.ID {
        var idName = CKRecord.ID()
            if let id = try? await container.userRecordID() {
                idName = id
            }
        return idName
        
    }
    
    public func checkIfProfileCreated() async throws -> Bool {
        var result = false
        if let data = try? await get(option: "all", format: "") {
            var trueCount = 0
            for i in 0 ..< data.count {
                let id = data[i].value(forKey: "accountNumber") as! CKRecord.Reference

                if userId?.recordName == id.recordID.recordName {
                    trueCount += 1
                }
            }
            
            if trueCount > 0 {
                result = true
            }
        }
        return result
    }
    
    public func createProfile() async {
        
            
        let recordProfile = CKRecord(recordType: "Profiles")
        let randomInt = Int.random(in: 10000..<99999)
        let randomAge = Int.random(in: 20..<80)
        recordProfile.setValue("user\(randomInt)", forKey: "username")
        recordProfile.setValue(randomAge, forKey: "age")
        recordProfile.setValue("nil", forKey: "achievement")
        recordProfile.setValue("nil", forKey: "motivation")
        recordProfile.setValue("nil", forKey: "story")

        try? await recordProfile.setValue(CKRecord.Reference(recordID: getUserID(), action: CKRecord.ReferenceAction.none), forKey: "accountNumber")

        DispatchQueue.main.async {
            self.db.save(recordProfile) { record, error in
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
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
            else if (dateFormatter.date(from: valArr[i]) != nil){
                if let changeVal = dateFormatter.date(from: valArr[i]) {
                    sortedVal.append(changeVal)
                }
            }
            else if valArr[i].contains("_"){
                sortedVal.append(CKRecord.ID(recordName: valArr[i]))
            }
            else {
                sortedVal.append(valArr[i])
            }
                    
        }
        for i in 0 ..< valArr.count {
            if valArr[i].contains("_") {
                record.setValue(CKRecord.Reference(recordID: sortedVal[i] as! CKRecord.ID, action: CKRecord.ReferenceAction.none), forKey: keyArr[i])
            }
            else {
                record.setValue(sortedVal[i], forKey: keyArr[i])
            }

        }
        db.save(record) { record, error in
            print(error ?? "saved")
        }


        
        
    }
        
    public func get(option: String, format: String) async throws -> [CKRecord]{
        //Cara ambil data per key -->> records.compactMap({$0.value(forKey: "nama keynya") as? String})
        let query: CKQuery?
        var dataReturn: [CKRecord] = []

        if option == "all" {
            query = CKQuery(recordType: recordString, predicate: NSPredicate(value: true))
            if let rec = try? await db.perform(query!, inZoneWith: nil) {
                dataReturn = rec
                
                
            }
        }
        else if option == "format" {
            query = CKQuery(recordType: recordString, predicate: NSPredicate(format: format))
            if let rec = try? await db.perform(query!, inZoneWith: nil) {
                dataReturn = rec
            }
            
        }
        
        
        return dataReturn
    }

    public func update(id: String, value: String, key: String) {
        let recordID = CKRecord.ID(recordName: id)
        let valArr = value.split(separator: ",").map{ String($0) }
        let keyArr = key.split(separator: ",").map{ String($0) }
        var sortedVal = [Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
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
            else if (dateFormatter.date(from: valArr[i]) != nil){
                if let changeVal = dateFormatter.date(from: valArr[i]) {
                    sortedVal.append(changeVal)
                }
            }
            else if valArr[i].contains("_"){
                sortedVal.append(CKRecord.ID(recordName: valArr[i]))
            }
            else if valArr[i].contains("file://") {
                let url = URL(string: valArr[i])
                sortedVal.append(CKAsset(fileURL: url!))
            }
            else {
                sortedVal.append(valArr[i])
            }
                    
        }
        db.fetch(withRecordID: recordID) { record, error in
            if error == nil {

                for i in 0 ..< valArr.count {
                    record?.setValue(sortedVal[i], forKey: keyArr[i])
                }

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
