//
//  DetailSentenceViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/17.
//

import UIKit
import Foundation

class DetailSentenceViewController: UIViewController {
    
    @IBOutlet weak var displayJaSentence: UIScrollView!
    @IBOutlet weak var displayEnSentence: UIScrollView!
    @IBOutlet weak var displayAddDate: UILabel!
    @IBOutlet weak var deleteSentenceButton: UIButton!
    var sentenceDetail:SentenceSet?
    var userid = UInt()
    
    let jaLabel = UILabel()
    let enLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 翻訳結果を表示させる枠の設定
        displayJaSentence.layer.borderColor = UIColor.black.cgColor
        displayJaSentence.layer.borderWidth = 1.0
        displayEnSentence.layer.borderColor = UIColor.black.cgColor
        displayEnSentence.layer.borderWidth = 1.0
        
        jaLabel.text = sentenceDetail?.japanese_sen
        jaLabel.numberOfLines = 0 // 複数行のテキストをサポート
        jaLabel.frame = CGRect(x: 0, y: 0, width: displayJaSentence.frame.width, height: 0)
        jaLabel.sizeToFit()
        displayJaSentence.addSubview(jaLabel)
        displayJaSentence.contentSize = jaLabel.frame.size // ビュー内のテキストをスクロール可能にする
        
        enLabel.text = sentenceDetail?.english_sen
        enLabel.numberOfLines = 0 // 複数行のテキストをサポート
        enLabel.frame = CGRect(x: 0, y: 0, width: displayEnSentence.frame.width, height: 0)
        enLabel.sizeToFit()
        displayEnSentence.addSubview(enLabel)
        displayEnSentence.contentSize = enLabel.frame.size // ビュー内のテキストをスクロール可能にする
        
        // 日時のファーマットおよび日本標準時(+9h)を設定
        // 入力の日時形式
        if let inputDateString = sentenceDetail?.created_at {
            
            // DateFormatterを作成して、入力形式を指定
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // 入力の形式に合わせて設定
            
            // 入力文字列をDateオブジェクトに変換
            if let inputDate = inputDateFormatter.date(from: inputDateString) {
                // DateFormatterを新しい形式で設定
                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "yyyy/MM/dd HH:mm" // 新しい形式に合わせて設定
                
                // 新しい形式の文字列にフォーマット
                let outputDateString = outputDateFormatter.string(from: inputDate)
                
                displayAddDate.text = outputDateString // 出力：2023/09/17 18:34
            } else {
                print("エラー：日時フォーマット変更の失敗")
            }
            
        } else {
            print("エラー：日時が存在しません")
        }
    }
    
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {

        
        let alertController = UIAlertController(title: "確認", message: "本当に削除しますか？", preferredStyle: .alert)

        // "はい" ボタン
        let yesAction = UIAlertAction(title: "削除", style: .destructive) { (_) in
            let sentencesDB = SentencesDB()
            sentencesDB.deleteSentences(userid: self.userid, sentenceid: self.sentenceDetail!.sentenceid) { result in
                switch result {
                case .success(let result):
                    print("\(result)")

                case .failure(let error):
                    print("エラー: \(error)")
                }
            }
        }

        // "キャンセル" ボタン
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)

        // アラートを表示
        self.present(alertController, animated: true, completion: nil)

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
