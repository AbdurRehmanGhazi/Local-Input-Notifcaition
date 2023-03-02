//
//  ViewController.swift
//  Action Category Notification
//
//  Created by Abdur Rehman on 02/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        message.text = UserDefaults().value(forKey: "message") as? String
    }

}

