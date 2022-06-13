//
//  ViewController.swift
//  Nilcotine
//
//  Created by Reza Mac on 08/06/22.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    var count = 0
    var dataArr: [String] = []
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "TestRecord")
    var ck2 = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let arr = try? await ck.get().compactMap({$0.value(forKey: "test_name") as? String})
            dataArr = arr!
            await ck2.createProfile()
            tableView.reloadData()

        }
//        ck.update(recordName: "8CF7E739-5ECE-41A0-AB66-260BE4A87B7D", key: "test_name", value: "gantiiiiii")

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
