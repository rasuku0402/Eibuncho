//
//  HomeViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/15.
//

import UIKit

class HomeViewController: UIViewController {
    
    var userid = UInt()
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutProcess(_ sender: UIButton) {
        let useridDB = UseridDB()
        useridDB.logOut() { result in
            switch result {
            case .success(let result):
                print("\(result)")

            case .failure(let error):
                print("エラー: \(error)")
            }
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // データを詳細画面に渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addSentenceSentenceVC = segue.destination as? AddSentenceViewController {
            addSentenceSentenceVC.userid = self.userid
        }
    }
    
//    @IBAction func tapAddSentenceScreenButton(_ sender: UIButton) {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
