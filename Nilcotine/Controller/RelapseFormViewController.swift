//
//  RelapseFormViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

import UIKit
import CloudKit

class RelapseFormViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var RelapseTextView: UITextView!
    
    var ck = CloudKitHandler(dbString: "iCloud.Nilcotine", recordString: "Relapses")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        RelapseTextView.text = "Share your story here..."
        RelapseTextView.textColor = UIColor.lightGray

        
        RelapseTextView.delegate = self
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your story here..."
            textView.textColor = UIColor.lightGray
        }
    }
    

    @IBAction func SubmitButtonPressed(_ sender: UIButton) {
        
        // TODO : Save UITextView User Inputed , Relapse Data ( Time )
        
        ck.insert(value: "Tanggal Berhenti", key: "endDate")
        ck.insertMultiple(value: "\(RelapseTextView.text ?? "nil" )", key: "effort")
        
        // if data = nil
        
        Task {
            let data = try await ck.get(option: "all", format: "")
            
            for i in 0 ..< data.count {
                let value = data[i].value(forKey: "effort") as! String
                if value == "nil" {
                    
                    RelapseTextView.text = "User does not input any story"
                    
                }
            }
            
        
        
        self.navigationController?.popViewController(animated: true)
        }
    
    
    
    
  
    
    }
    
}
    


