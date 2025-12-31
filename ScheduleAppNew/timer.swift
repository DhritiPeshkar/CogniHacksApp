//
//  timer.swift
//  ScheduleAppNew
//
//  Created by Dhriti Peshkar on 8/30/25.
import SwiftUI

struct TimerView: View {
    @State private var timeRemaining = 600 // 10 minutes
    @State private var isPaused = true
    @State private var timer: Timer? = nil
    @State private var message = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Break Timer")
                .font(.largeTitle)
                .foregroundColor(Color("TitleColor")) // Define in Assets
            
            Text(message)
                .font(.title2)
                .foregroundColor(.green)
                .frame(height: 40)
            
            Text(timeString(from: timeRemaining))
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.blue)
            
            HStack(spacing: 20) {
                Button(action: startPauseTapped) {
                    Text(isPaused ? "▶️ Start" : "⏸️ Pause")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isPaused ? Color.blue : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: resetTapped) {
                    Text("🔄 Reset")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: 400)
        }
        .padding()
        .background(Color("BackgroundColor")) // Define in Assets
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    // MARK: - Timer Methods
    
    func startPauseTapped() {
        if isPaused {
            isPaused = false
            message = ""
            startTimer()
        } else {
            isPaused = true
            timer?.invalidate()
        }
    }
    
    func resetTapped() {
        timer?.invalidate()
        isPaused = true
        timeRemaining = 600
        message = ""
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isPaused = true
                message = "🎉 Break is Over! 🎉"
            }
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Preview
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.light)
    }
}


