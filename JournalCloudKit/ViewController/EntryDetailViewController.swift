//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Ivan Ramirez on 9/24/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry?{
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateViews(){
        titleTextField.text = entry?.title
        bodyTextView.text = entry?.textBody
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let textBody = bodyTextView.text else {return}
        if let entry = entry {
            
            EntryController.shared.updateEntry(entry: entry, title: title, textBody: textBody) { (success) in
                if success {
                    print("Success updating Entry")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("failure creating new entry")
                }
            }
        } else {
            EntryController.shared.addEntryWith(title: title, textBody: textBody) { (success) in
                if success{
                    print("SUCCESS creating new entry")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                    print("Failure creating new entry")
                }
            }
        }
    }
}

