//
//  SentenceViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/14.
//

import UIKit

class SentenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userid = UInt()
    var sentenceData = [SentenceSet]()
    
    @IBOutlet weak var SentencesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SentencesTableView.dataSource = self // tableを表示するために必須
        SentencesTableView.delegate = self // tableを表示するために必須
        
        // 初期ロード
        let sentencesDB = SentencesDB()
        sentencesDB.getSentences(userid: userid) { result in
            switch result {
            case .success(let result):
                print("取得結果: \(result)")
                self.sentenceData = result
                DispatchQueue.main.async { // メインスレッドで実行
                    self.SentencesTableView.reloadData()
                }

            case .failure(let error):
                print("エラー: \(error)")
            }
        }
        
        // ユーザが更新したい時にロードを行う関数
        configureRefreshControl()
    }
    
    // ViewControllerが表示される直前に行う処理
    override func viewWillAppear(_ animated: Bool) {
        
//        let sentencesDB = SentencesDB()
//        sentencesDB.getSentences(userid: userid) { result in
//            switch result {
//            case .success(let result):
//                print("取得結果: \(result)")
//                self.sentenceData = result
//                DispatchQueue.main.async { // メインスレッドで実行
//                    self.SentencesTableView.reloadData()
//                }
//
//            case .failure(let error):
//                print("エラー: \(error)")
//            }
//        }
        
        // 詳細から戻った時にセル選択状態を解除する
        if let indexPath = self.SentencesTableView.indexPathForSelectedRow{
            self.SentencesTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // データを詳細画面に渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailSentenceVC = segue.destination as? DetailSentenceViewController {
            detailSentenceVC.sentenceDetail = sender as? SentenceSet
            detailSentenceVC.userid = self.userid
        }
    }
    
    // 表示する行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentenceData.count
    }
    
    // 表示する要素
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentencesTableViewCell", for: indexPath)
//        let jaLabel = cell.viewWithTag(1) as? UILabel
//        jaLabel?.text = sentenceData[indexPath.row].japanese_sen
        
//        let iconLabel = cell.viewWithTag(2) as? UILabel
//        iconLabel?.text = forecasts[indexPath.row].getIconText()
        
        cell.textLabel!.text = sentenceData[indexPath.row].japanese_sen

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDetailSentence", sender: sentenceData[indexPath.row])
    }
    
    //RefreshControlを追加する処理
    func configureRefreshControl () {
        SentencesTableView.refreshControl = UIRefreshControl()
        SentencesTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        let sentencesDB = SentencesDB()
        sentencesDB.getSentences(userid: userid) { result in
            switch result {
            case .success(let result):
                print("取得結果: \(result)")
                self.sentenceData = result
                DispatchQueue.main.async { // メインスレッドで実行
                    self.SentencesTableView.reloadData()
                }

            case .failure(let error):
                print("エラー: \(error)")
            }
        }

       DispatchQueue.main.async {
          self.SentencesTableView.reloadData()  //TableViewの中身を更新する場合はここでリロード処理
          self.SentencesTableView.refreshControl?.endRefreshing()
       }
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
