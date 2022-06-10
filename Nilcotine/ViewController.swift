//
//  ViewController.swift
//  Nilcotine
//
//  Created by Reza Mac on 08/06/22.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    private let db = CKContainer(identifier: "iCloud.Nilcotine").publicCloudDatabase
    let record = CKRecord(recordType: "TestRecord")

    @IBOutlet weak var tableView: UITableView!
    var count = 0
    var dataArr: [String] = []
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "TestRecord")
    override func viewDidLoad() {
        super.viewDidLoad()
//        record.setValue("test terakhir", forKey: "test_name")
//        db.save(record) { record, error in
//            print(error ?? "saved")
//        }
        
//        let query = CKQuery(recordType: "TestRecord", predicate: NSPredicate(value: true))
//        db.fetch(withQuery: query) { records in
//            let recordsArrCount = records.map { $0.matchResults.count }
////            for i in 0 ..< recordsArrCount {
////                print("aaaa")
////            }
//            print(recordsArrCount)
//            let data = records.flatMap({$0.matchResults[1].1.map({$0.value(forKey: "test_name")!})})
//
//            do {
//                let value = try data.get() as! String
//                print(value)
//            } catch {
//                print("Error retrieving the value: \(error)")
//            }
//
//        }
        
//        db.perform(query, inZoneWith: nil) { records, err in
//            guard let records = records, err == nil else {
//                return
//            }
//            print(records.compactMap({$0.value(forKey: "test_name") as? String}))
//        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
