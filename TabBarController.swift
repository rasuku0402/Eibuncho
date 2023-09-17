//
//  TabBarController.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/15.
//

import UIKit

class TabBarController: UITabBarController {
    
    var userid = UInt()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("userID: \(userid)")
        
        // HomeViewへuserIDを渡す
        if let vc = self.viewControllers?[0] as? HomeViewController {
            vc.userid = userid
        }
        // SentenceViewへuserIDを渡す
        if let nc = self.viewControllers?[1] as? UINavigationController,
           let vc = nc.viewControllers[0] as? SentenceViewController {
            vc.userid = userid
        }
        // WordViewへuserIDを渡す
//        if let vc = self.viewControllers?[2] as? WordViewController {
//            vc.userid = userid
//        }
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
