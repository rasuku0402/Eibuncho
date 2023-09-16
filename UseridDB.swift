//
//  UseridDB.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/15.
//

import Foundation

public class UseridDB {
    // ログイン
    func logIn(address: String, password: String, completion: @escaping (Result<UInt, Error>) -> Void) {
        let endpoint = "http://52.199.139.250:8080/login"
        
        // HTTPリクエスト用のURLを作成
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        // HTTPメソッドを設定
        request.httpMethod = "POST"
        
        // リクエストヘッダー
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // リクエストボディ
        let body: [String: String] = [
            "email": "\(address)",
            "password": "\(password)"
        ]

        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonBody
//
//        let json = try? JSONSerialization.jsonObject(with: jsonBody!, options: []) as? [String: String]
//        print(json!)
        
        // リクエストを送信し、非同期でレスポンスを取得
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataReceived))
                return
            }
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            }
            // レスポンスを処理
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userid_int = json["userid"] as? UInt {
                    completion(.success(userid_int))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    
    enum APIError: Error {
        case invalidURL
        case invalidRequestBody
        case noDataReceived
        case invalidResponse
    }
}
