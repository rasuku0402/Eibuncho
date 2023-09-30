//
//  AddSentenceViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/08.
//

import UIKit

class AddSentenceViewController: UIViewController {

    @IBOutlet weak var japaneseSentence: UITextField!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var englishSentence: UIScrollView!
    @IBOutlet weak var addButton: UIButton!
    
    var userid = UInt()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        japaneseSentence.placeholder = "翻訳したい文章を日本語で入力してください。"
        // 翻訳結果を表示させる枠の設定
        englishSentence.layer.borderColor = UIColor.black.cgColor
        englishSentence.layer.borderWidth = 1.0
        // 初期状態ではボタンは無効
        translateButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    // テキストボックスに入力したら翻訳ボタンを有効化
    @IBAction func TextFieldActionBtnInactive(_ sender: Any) {
        if japaneseSentence.text == "" {
            translateButton.isEnabled = false
            addButton.isEnabled = false
        } else {
            translateButton.isEnabled = true
        }
    }
    
    // 翻訳ボタンをおした時の挙動
    @IBAction func tapTranslateButton(_ sender: UIButton) {
        // 翻訳結果を初期化
        englishSentence.subviews.forEach { $0.removeFromSuperview() }
        
        // OpenAIClientのインスタンスを作成
//        let openaiClient = OpenAIClient()
        // DeepLClientのインスタンスを作成
        let deeplClient = DeepLClient()
        
        let text = japaneseSentence.text!

        var displayedText = "No content"

        let semaphore = DispatchSemaphore(value: 0)
        
//        openaiClient.callOpenAI(prompt: text) { result in
        deeplClient.callDeepL(prompt: text) { result in
            switch result {
            case .success(let translatedText):
                displayedText = translatedText
                print("translate success!")
                // メインスレッドで実行
                DispatchQueue.main.async {
                    // 追加ボタンを有効化
                    self.addButton.isEnabled = true
                }
            case .failure(let error):
                displayedText = "error"
                print("エラー: \(error)")
                // メインスレッドで実行
                DispatchQueue.main.async {
                    // 追加ボタンを無効化
                    self.addButton.isEnabled = false
                }
            }
            
            semaphore.signal() // 非同期処理が完了したことを通知
        }
        
        // 非同期処理が完了するまで待機
        _ = semaphore.wait(timeout: .distantFuture)
        
        
        label.text = displayedText
        label.numberOfLines = 0 // 複数行のテキストをサポート
        label.frame = CGRect(x: 0, y: 0, width: englishSentence.frame.width, height: 0)
        label.sizeToFit()
        englishSentence.addSubview(label)
        // ビュー内のテキストをスクロール可能にする
        englishSentence.contentSize = label.frame.size
        
        // キーボードを閉じる
        japaneseSentence.resignFirstResponder()
        
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        // ここにデータベースへ追加するコードを記述する
        let sentencesDB = SentencesDB()
        sentencesDB.addSentence(userid: self.userid, ja_prompt: japaneseSentence.text!, en_prompt: label.text!) { result in
            switch result {
            case .success(let result):
                print("\(result)")

            case .failure(let error):
                print("エラー: \(error)")
            }
        }
        
        //テキストボックスに空文字を入れる
        self.japaneseSentence.text = ""
        englishSentence.subviews.forEach { $0.removeFromSuperview() }
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
