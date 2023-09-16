//
//  SentenceViewController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/14.
//

import UIKit

class SentenceViewController: UIViewController {
//class SentenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userid = UInt()
    
    @IBOutlet weak var SentencesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        SentencesTableView.dataSource = self
//        SentencesTableView.delegate = self
        
        let sentencesDB = SentencesDB()
        sentencesDB.getSentences(userid: userid) { result in
            switch result {
            case .success(let result):
//                var sentences = result
//                print("取得結果: \(result)")
                print(result[1])
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
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
