//
//  ContentView.swift
//  ScheduleApp
//
//  Created by Dhriti Peshkar on 8/30/25.
//

import SwiftUI

struct ContentView: View {
    let apiKey: String

    init() {
            self.apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String ?? "nil"
            print("API Key:", self.apiKey) // should print your actual key
    }

    var body: some View {
        VStack {
            Text("Loaded API Key:")
            Text(apiKey)
                .font(.caption)
                .foregroundColor(.gray)

            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
