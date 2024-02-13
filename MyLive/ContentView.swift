//
//  ContentView.swift
//  MyLive
//
//  Created by Kwaw Annan on 2/11/24.
//

import SwiftUI
import AVFoundation

import SwiftUI

struct ContentView: View {
    @State private var isFrontCamera = true
    @State private var viewerCount: Int = Int.random(in: 50_000...100_000) // Random number for viewers
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect() // Timer to update the viewer count
    @State private var chatMessages = loadChatMessages()
    @State private var displayedMessages: [ChatMessage] = []
    @State private var chatTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    
    
    var body: some View {
        ZStack {
            CameraView()
                .edgesIgnoringSafeArea(.all) // Makes the camera view fullscreen
            
            
            VStack {
                HStack {
                    // Placeholder image for the user
                    Image("userPlaceholder") // Replace "userPlaceholder" with your image asset
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30) // Adjust size as needed
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 3)
                    // Username and LIVE label
                    Text("checkm8hunter")
                        .foregroundColor(.white)
                        .padding(.leading)
                        .font(.callout)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    
                    Spacer()
                    // Viewer count label
                    Text("\(viewerCount) viewers")
                        .foregroundColor(.white)
                        .padding(5)
                        .font(.caption)
                        .background(Color.gray.opacity(0.75))
                        .cornerRadius(2)
                        .onReceive(timer) { _ in
                            let changePercent = Double.random(in: 0.9...1.1) // Random change between 90% (decrease) and 110% (increase)
                            let change = Int(Double(viewerCount) * changePercent)
                            viewerCount = max(0, change) // Ensure viewer count doesn't go below 0
                        }
                    
                    // LIVE label
                    Text("LIVE")
                        .foregroundColor(.white)
                        .padding(5)
                        .font(.caption)
                        .background(Color.red.opacity(0.75))
                        .cornerRadius(2)
                    
                    // Close button
                    Button(action: {
                        // Action for the close button
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.top, 5)
                
                Spacer()
                VStack {
                    // Random chat display (just above the chat box)
                    ScrollView {
                        ForEach(displayedMessages) { message in
                            ChatMessageView(message: message)
                        }
                    }
                    .frame(maxHeight: 150)
                    
                    // Chat box at the bottom
                    HStack {
                        TextField("Chat message...", text: .constant(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: 44)
                        Button(action: {
                            // Handle send action
                        }) {
                            Image(systemName: "paperplane.fill")
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 200) // Adjust the height as needed
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100) // Adjust position as needed
            }
            .onReceive(chatTimer) { _ in
                addRandomMessage()
            }
            
            
            HStack {
                Button(action: {
                    // Action for the flip camera button
                    isFrontCamera.toggle()
                }) {
                    Image(systemName: "camera.rotate")
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
                Button(action: {
                    // Action for the flash button
                }) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            
        }
    }
    // Adds a random message to the displayed messages
    private func addRandomMessage() {
        if let randomMessage = chatMessages.randomElement() {
            displayedMessages.append(randomMessage)
            // Keep only the last few messages to simulate a chat window
            if displayedMessages.count > 5 {
                displayedMessages.removeFirst()
            }
        }
    }
    
    
}



struct ChatMessage: Identifiable, Decodable {
    var id: Int
    var username: String
    var message: String
}

// Dummy function to simulate loading chat messages from a JSON file
func loadChatMessages() -> [ChatMessage] {
    // Here, you would load your JSON file and parse the chat messages
    // Since there's no file access in this environment, let's return a dummy array
    return (1...100).map { id in
        ChatMessage(id: id, username: "User \(id)", message: "This is message number \(id)")
    }
}
struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            Text(message.username).bold()
            Text(": \(message.message)")
        }
        .padding(5)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(5)
    }
}

#Preview {
    ContentView()
}
