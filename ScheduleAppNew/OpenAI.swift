//
//  OpenAI.swift
//  ScheduleAppNew
//
//  Created by Dhriti Peshkar on 8/30/25.
//

import Foundation

class OpenAIService {
    let apiKey: String

    // Accept the API key in the initializer
    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func sendPrompt(prompt: String, completion: @escaping (String?) -> Void) {
        // If key is "nil" just return fake response for safety
        if apiKey == "nil" {
            completion("[Preview Mode] Example AI response for: \(prompt)")
            return
        }
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        let json: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ]
        ]

        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }

            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(content)
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}

