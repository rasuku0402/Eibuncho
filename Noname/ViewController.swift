//
//  ViewController.swift
//  Noname
//
//  Created by 菊地泰斗 on 2023/08/22.
//

import UIKit

//protocol VCDelegate: AnyObject {
//    func setValue(_ value: String)
//}


class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.isEnabled = false
        errorMsg.text = ""
    }
    
    @IBAction func loginBtnInactive(_ sender: Any) {
        if email.text == "" || pass.text == "" {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
    }
    
    // 画面遷移
    @IBAction func checkLogIn(_ sender: UIButton) {
        let useridDB = UseridDB()
        useridDB.logIn(address: email.text!, password: pass.text!) { result in
            switch result {
            case .success(let result):
//                print("userID: \(result)")
                
                // メインスレッドで実行
                DispatchQueue.main.async {
                    // TabBarControllerへuserIDを渡す
                    let tc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarID") as! TabBarController
                    tc.userid = result
                    self.present(tc, animated: true, completion: nil) // 渡して遷移する
                }

            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
//        self.performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    // テキストボックス外をタップした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

