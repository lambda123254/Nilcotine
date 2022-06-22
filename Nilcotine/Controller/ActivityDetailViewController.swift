//
//  ActivityDetailViewController.swift
//  Nilcotine
//
//  Created by Reza Mac on 14/06/22.
//

import UIKit

class ActivityDetailViewController: UIViewController {

    var titleLabelString = ""
    var daysLabelString = ""
    var effortTextViewString = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var effortTextView: UITextView!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var daysLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = true

        self.tabBarController?.tabBar.isHidden = true
        
        effortTextView.isEditable = false
        titleLabel.text = titleLabelString
        daysLabel.text = daysLabelString
        effortTextView.text = effortTextViewString
        // Do any additional setup after loading the view.
    }
    
    @IBAction func visitProfileBtnPressed(_ sender: Any) {
        let nextView = storyBoard.instantiateViewController(withIdentifier: "ProgressView") as! ProgressViewController
        self.navigationController?.pushViewController(nextView, animated: true)
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
