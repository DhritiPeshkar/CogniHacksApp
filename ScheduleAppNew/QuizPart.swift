import SwiftUI
import SwiftData

struct ScheduledTask: Identifiable, Codable {
    let id = UUID()
    let name: String
    let startTime: String
    let endTime: String
}


func buildPrompt(from items: [Item]) -> String {
    var prompt = """
    You are a scheduling assistant. Arrange these tasks into a logical daily schedule starting at 7:30 AM and ending at 10:00 PM. MAKE SURE to add breakfast, lunch, and dinner in a logical manner with the other given tasks. 

    Return ONLY valid JSON, no extra text, in this exact format:
    [
      {"name": "Task Name", "startTime": "HH:MM", "endTime": "HH:MM"},
      ...
    ]

    Tasks:
    """

    for item in items {
        let totalMinutes = item.durationHours * 60 + item.durationMinutes
        prompt += "- \(item.name): \(totalMinutes) minutes\n"
    }
    return prompt
}

func fetchSchedule(from items: [Item], completion: @escaping ([ScheduledTask]?) -> Void) {
    let prompt = buildPrompt(from: items)
    
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "")", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
        "model": "gpt-4o-mini",
        "messages": [["role": "user", "content": prompt]],
        "temperature": 0
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
        if let error = error {
            print("Network error:", error)
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code:", httpResponse.statusCode)
        }
        
        if let data = data, let rawString = String(data: data, encoding: .utf8) {
            print("Raw API response:\n\(rawString)")
        }
        
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            completion(nil)
            return
        }
        
        let cleaned = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Cleaned content:\n\(cleaned)")
        
        if let scheduleData = cleaned.data(using: .utf8),
           let schedule = try? JSONDecoder().decode([ScheduledTask].self, from: scheduleData) {
            completion(schedule)
        } else {
            print("Failed to decode schedule JSON")
            completion(nil)
        }
    }
    .resume()
}




struct QuizPart: View {
    @State private var schedule: [ScheduledTask] = []
    @State private var statusMessage: String? = nil
    @Query(sort: \Item.timestamp, order: .reverse)
    private var items: [Item]
    var body: some View {
        VStack {
            Button("Generate AI Schedule") {
                guard !items.isEmpty else {
                    statusMessage = "No tasks to schedule"
                    return
                }
                statusMessage = "Scheduling..."
                fetchSchedule(from: items) { result in
                    DispatchQueue.main.async {
                        if let result = result {
                            schedule = result
                            statusMessage = "Got schedule!"
                        } else {
                            statusMessage = "Failed to get schedule"
                        }
                    }
                }
            }
            .padding()
            
            if let statusMessage = statusMessage {
                Text(statusMessage)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            
            List(schedule) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.headline)
                    Text("\(task.startTime) - \(task.endTime)").font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    QuizPart()
        .modelContainer(for: Item.self, inMemory: true)
}
