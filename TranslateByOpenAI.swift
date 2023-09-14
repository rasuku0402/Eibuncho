//
//  TranslateByOpenAI.swift
//  Noname
//
//  Created by 釆山怜央 on 2023/09/09.
//

import Foundation

// OpenAIを呼び出すクラス
public class OpenAIClient {
    
    private lazy var apiKey: String = self.fetchAPIKey()
    
    // config.plistからAPI keyを取得する関数
    public func fetchAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "config", ofType: "plist") {
            if let plist = NSDictionary(contentsOfFile: path) {
                if let apiKey = plist["Reo's OpenAI key"] as? String {
                    return apiKey
                }
            }
        }
        //エラー時のデフォルト値を指定
        return "key error"
    }
    
    // 非同期関数でOpenAI APIを呼び出し、指定されたテキストを英訳して結果を返す
    func callOpenAI(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "https://api.openai.com/v1/completions"
        
        // HTTPリクエスト用のURLを作成
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        // HTTPメソッドを設定（POSTリクエストの場合）
        request.httpMethod = "POST"
        
        // ヘッダーを設定
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // リクエストボディを設定
        let parameters: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": "Translate the following Japanese text to English text: '\(prompt)'",
            "max_tokens": 50
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(APIError.invalidRequestBody))
            return
        }
        
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
                print(string) // "Hello"
            }
            // レスポンスを処理
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let translatedText = choices.first?["text"] as? String {
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

    enum APIError: Error {
        case invalidURL
        case invalidRequestBody
        case noDataReceived
        case invalidResponse
    }
}

// DeepLを呼び出すクラス
public class DeepLClient {
    
    private lazy var apiKey: String = self.fetchAPIKey()
    
    // config.plistからAPI keyを取得する関数
    public func fetchAPIKey() -> String {
        if let path = Bundle.main.path(forResource: "config", ofType: "plist") {
            if let plist = NSDictionary(contentsOfFile: path) {
                if let apiKey = plist["Reo's DeepL key"] as? String {
                    return apiKey
                }
            }
        }
        //エラー時のデフォルト値を指定
        return "key error"
    }
    
    // 非同期関数でDeepL APIを呼び出し、指定されたテキストを英訳して結果を返す
    func callDeepL(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "https://api-free.deepl.com/v2/translate"
        
        // HTTPリクエスト用のURLを作成
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        // HTTPメソッドを設定（POSTリクエストの場合）
        request.httpMethod = "POST"
        
        // リクエストヘッダー
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // リクエストボディ
        let parameters: [String: Any] = [
            "text": ["\(prompt)"],
            "target_lang": "EN"
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

    enum APIError: Error {
        case invalidURL
        case invalidRequestBody
        case noDataReceived
        case invalidResponse
    }
}
