//
//  SpeechRecognizer.swift
//  NativeASRApp
//
//  Created by Kosuke Mori on 2026/03/16.
//

import Foundation
import Combine

@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var statusMessage: String = "waiting"
    @Published var errorMessage: String?
    
    func requestAuthorization() {
        
    }
    
    func startRecognition() {
        
    }
    
    func stopRecognition() {
        
    }
    
    func clearTranscript() {
        
    }
}
