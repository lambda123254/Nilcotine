//
//  ActivityViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 13/06/22.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableActivity: UITableView!
    
    struct Activity {
        let name: String
        let age: String
        let desc: String
        let imageIcon: String
    }
    
    let data: [Activity] = [
        Activity(name: "Samuel Dennis", age: "24 yo", desc: "Samuel Dennis relapsed after 12 days of trying", imageIcon: "ActivityIcon"),
        Activity(name: "Bene Rajagukguk", age: "24 yo", desc: "Bene Rajagukguk earn trophy for completing 12 days of no smoking", imageIcon: "ActivityIcon"),
        Activity(name: "Bene Rajagukguk", age: "24 yo", desc: "Bene Rajagukguk earn trophy for completing 12 days of no smoking", imageIcon: "ActivityIcon"),
        Activity(name: "Samuel Dennis", age: "24 yo", desc: "Samuel Dennis relapsed after 12 days of trying", imageIcon: "ActivityIcon"),
        Activity(name: "Samuel Dennis", age: "24 yo", desc: "Samuel Dennis relapsed after 12 days of trying", imageIcon: "ActivityIcon"),
    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableActivity.dataSource = self
        tableActivity.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = data[indexPath.row]
        let cell = tableActivity.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActivityTableViewCell
        cell.labelName.text = activity.name
        cell.labelDesc.text = activity.desc
        cell.labelAge.text = activity.age
        cell.activityIconImageView.image = UIImage(named: activity.imageIcon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    

}
