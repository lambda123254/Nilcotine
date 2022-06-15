//
//  RelapseFormViewController.swift
//  Nilcotine
//
//  Created by Victor Hartanto on 14/06/22.
//

import UIKit

class RelapseFormViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var RelapseTextView: UITextView!
    
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
        
        self.navigationController?.popViewController(animated: true)
        }
    
  
    
    }
    


