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
            if let check = try? await ck.checkIfProfileCreated() {
                if check {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextView = storyBoard.instantiateViewController(withIdentifier: "TabBarView") as! TabBarController
                    nextView.modalPresentationStyle = .fullScreen
                    nextView.modalTransitionStyle = .crossDissolve
                    self.present(nextView, animated: true)
                }
            }
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
