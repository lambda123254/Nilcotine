//
//  EditProfileViewController.swift
//  Nilcotine
//
//  Created by Samuel Dennis on 21/06/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var pickerAge: UIPickerView!
    
    @IBOutlet weak var labelCountCharMotivation: UILabel!
    @IBOutlet weak var textViewMotivation: UITextView!
    
    @IBOutlet weak var labelCountCharStory: UILabel!
    @IBOutlet weak var textViewStory: UITextView!
    var data: [String] = []
    
    var countTextViewStory = 0
    var countTextViewMotivation = 0
    var maxMotivationBool = false
    var maxStoryBool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1 ... 99 {
            data.append(String(i))
        }

        pickerAge.dataSource = self
        pickerAge.delegate = self
        
        textViewMotivation.delegate = self
        textViewStory.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

}
extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}

extension EditProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView === textViewMotivation {
            if textViewMotivation.text.count > 150 {
                textViewMotivation.text = String(textViewMotivation.text.dropLast())
            }
            labelCountCharMotivation.text = String(textViewMotivation.text.count)

        }
        else if textView === textViewStory {
            if textViewStory.text.count > 250 {
                textViewStory.text = String(textViewStory.text.dropLast())
            }
            labelCountCharStory.text = String(textViewStory.text.count)
        }
    }
}


