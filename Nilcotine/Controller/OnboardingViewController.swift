//
//  OnboardingViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 09/06/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Profiles")

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            try await  ck.createProfile()
        }
        // Do any additional setup after loading the view.
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
