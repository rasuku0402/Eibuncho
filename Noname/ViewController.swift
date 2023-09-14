//
//  ViewController.swift
//  Noname
//
//  Created by 菊地泰斗 on 2023/08/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.isEnabled = false
    }
    
    @IBAction func loginBtnInactive(_ sender: Any) {
        if userID.text == "" || password.text == "" {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }

}

