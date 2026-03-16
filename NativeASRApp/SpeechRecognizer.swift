//
//  SpeechRecognizer.swift
//  NativeASRApp
//
//  Created by Kosuke Mori on 2026/03/16.
//

import Foundation
import Speech
import AVFAudio
import Combine

@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var statusMessage: String = "waiting"
    @Published var errorMessage: String?
    
    func requestAuthorization() {
        statusMessage = "checking authorization..."
        errorMessage = nil
        
        Task {
            let speechStatus = await requestSpeechRecognitionAuthorization()
            guard speechStatus == .authorized else {
                statusMessage = "speech recognition is not available."
                errorMessage = "speech recognition authorization failed."
                return
            }
            
            let microphoneStatus = await requestMicrophoneAuthorization()
            guard microphoneStatus else {
                statusMessage = "microphone access is not available."
                errorMessage = "microphone authorization failed."
                return
            }
            
            statusMessage = "ready"
            errorMessage = nil
        }
    }
    
    private func requestSpeechRecognitionAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
    
    private func requestMicrophoneAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    func startRecognition() {
        
    }
    
    func stopRecognition() {
        
    }
    
    func clearTranscript() {
        
    }
}
