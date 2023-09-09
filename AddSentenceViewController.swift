//
//  AddSentenceViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/08.
//

import UIKit

class AddSentenceViewController: UIViewController {

    @IBOutlet weak var japaneseSentence: UITextField!
    @IBOutlet weak var englishSentence: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        japaneseSentence.placeholder = "翻訳したい文章を日本語で入力してください。"
        englishSentence.layer.borderColor = UIColor.black.cgColor
        englishSentence.layer.borderWidth = 1.0
    }
    
    @IBAction func addButton(_ sender: Any) {
        
//        guard let Text = self.japaneseSentence.text else { return }
//        self.englishSentence.text = Text
        //TextFieldに空文字を入れる
        self.japaneseSentence.text = ""
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
