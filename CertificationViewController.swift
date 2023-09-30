//
//  CertificationViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/30.
//

import UIKit

class CertificationViewController: UIViewController {

    @IBOutlet weak var PINcode: UITextField!
    @IBOutlet weak var certificationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PINcode.keyboardType = UIKeyboardType.numberPad
        certificationButton.isEnabled = false
        errorMsg.text = ""
    }
    
    // ボタンの有効化
    @IBAction func certificationBtnInactive(_ sender: Any) {
        if PINcode.text == "" {
            certificationButton.isEnabled = false
        } else {
            certificationButton.isEnabled = true
        }
    }
    
    // 画面遷移
    @IBAction func checkSignUp(_ sender: UIButton) {
        let useridDB = UseridDB()
        useridDB.twiceCertification(pin: PINcode.text!) { result in
            switch result {
            case .success(let result):
                print("\(result)")

                // メインスレッドで実行
                DispatchQueue.main.async {
                    // テキストボックスとボタンを初期化
                    self.PINcode.text = ""
                    self.errorMsg.text = ""

                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }

            case .failure(let error):
                print("エラー: \(error)")
                
                // メインスレッドで実行
                DispatchQueue.main.async {
                    // テキストボックスとボタンを初期化
                    self.errorMsg.text = "PINコードが間違っているか、期限が切れています"
                }
            }
        }
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
