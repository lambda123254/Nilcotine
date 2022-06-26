//
//  AchievementFormViewController.swift
//  Nilcotine
//
//  Created by Reza Mac on 26/06/22.
//

import UIKit
import CloudKit

protocol AllAchievementFormDelegateProtocol {
    func refresh()
}

class AchievementFormViewController: UIViewController {
    var delegate: AllAchievementFormDelegateProtocol? = nil

    var achievementName = ""
    var achievementImageString = ""
    var userIdString = ""
    @IBOutlet weak var effortTextView: UITextView!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Achievements")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(achievementName)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        ck.insertMultiple(value: "\(userIdString),\(achievementName),\(achievementImageString),\(effortTextView.text!)", key: "accountNumber,achivementName,iconName,story")
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
