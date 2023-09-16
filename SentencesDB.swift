//
//  DBofSectences.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/14.
//

import Foundation

public class SentencesDB {
    
    // 例文新規登録
    func addSentence(userid: String, ja_prompt: String, en_prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "http://52.199.139.250:8080/\(userid)/sentences"
        
        // HTTPリクエスト用のURLを作成
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        // HTTPメソッドを設定（POSTリクエストの場合）
        request.httpMethod = "POST"
        
        // リクエストボディ
        let parameters: [String: Any] = [
            "japanese_sen": "\(ja_prompt)",
            "english_sen": "\(en_prompt)"
        ]

        let jsonBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonBody
        
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
                   let translations = json["translations"] as? [[String: Any]],
                   let translatedText = translations.first?["text"] as? String {
                    completion(.success(translatedText))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    // 例文一覧取得
    func getSentences(userid: UInt, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let endpoint = "http://52.199.139.250:8080/\(userid)/sentences"
        print(endpoint)
        
        // HTTPリクエスト用のURLを作成
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        // HTTPメソッドを設定
        request.httpMethod = "GET"
        
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
//            // レスポンスを処理
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(.success(json))
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
