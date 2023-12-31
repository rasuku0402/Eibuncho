//
//  CreateAccountViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/11.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createAccountButton.isEnabled = false
    }
    
    // ボタンの有効化
    @IBAction func createAccountBtnInactive(_ sender: Any) {
        if email.text == "" || pass.text == "" {
            createAccountButton.isEnabled = false
        } else {
            createAccountButton.isEnabled = true
        }
    }
    
    // 画面遷移
    @IBAction func checkSignUp(_ sender: UIButton) {
        let useridDB = UseridDB()
        useridDB.signUp(username: userName.text!, address: email.text!, password: pass.text!) { result in
            switch result {
            case .success(let result):
                print("\(result)")

                // メインスレッドで実行
                DispatchQueue.main.async {
                    // テキストボックスとボタンを初期化
                    self.userName.text = ""
                    self.email.text = ""
                    self.pass.text = ""
//                    self.createAccountButton.isEnabled = false
                }

            case .failure(let error):
                print("エラー: \(error)")
            }
        }
        // 画面遷移
//        self.performSegue(withIdentifier: "toLogIn", sender: nil)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // テキストボックス外をタップした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
