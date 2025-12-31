import SwiftUI
import SwiftData


struct Task: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    
    @State private var name: String = ""
    @State private var duration: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Task Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                TextField("Duration (minutes)", text: $duration)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Button("Add Task") {
                    guard let durationInt = Int(duration), !name.isEmpty else { return }
                    let hours = durationInt / 60
                    let minutes = durationInt % 60
                    let newItem = Item(timestamp: Date(), name: name, durationHours: hours, durationMinutes: minutes)
                    modelContext.insert(newItem)
                    name = ""
                    duration = ""
                }
                .padding()

                NavigationLink(destination: QuizPart()) {
                    Text("Schedule...")
                }
                .padding()

                List(items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(String(format: "%02d:%02d", item.durationHours, item.durationMinutes))
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
