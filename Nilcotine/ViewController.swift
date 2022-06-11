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
        
        Task {
            let arr = try? await ck.get().compactMap({$0.value(forKey: "test_name") as? String})
            dataArr = arr!
            tableView.reloadData()
        }


        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
}
