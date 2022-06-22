//
//  OnboardingViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 09/06/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Activities")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startedButtonPressed(_ sender: Any) {
        Task {
            try? await ck.createProfile()
        }
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
