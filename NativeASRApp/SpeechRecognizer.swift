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
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
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
        errorMessage = nil
        statusMessage = "recognizing..."
        
        stopRecognition()
        
        guard let speechRecognizer else {
            statusMessage = "speech recognizer is not available."
            errorMessage = "speech recognition initialization failed."
            return
        }
        
        guard speechRecognizer.isAvailable else {
            statusMessage = "speech recognizer is not available."
            errorMessage = "speech recognition service is not available."
            return
        }
        
        do {
            // record session
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
            // recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest else {
                statusMessage = "speech recognition request failed."
                errorMessage = "speech recognition request is not available."
                return
            }
            
            // input node
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }
            
            // recognition task
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self else { return }
                
                if let result {
                    self.transcript = result.bestTranscription.formattedString
                }
                
                if let error {
                    statusMessage = "error happened."
                    errorMessage = error.localizedDescription
                    stopRecognition()
                    return
                }
                
                if result?.isFinal == true {
                    self.statusMessage = "recognition finished"
                    stopRecognition()
                }
            }
            
            // start audioEngine
            audioEngine.prepare()
            try audioEngine.start()
            
            isRecording = true
            statusMessage = "recognizing..."
            
        } catch {
            statusMessage = "record is not available."
            errorMessage = error.localizedDescription
        }
    }
    
    func stopRecognition() {
        
    }
    
    func clearTranscript() {
        
    }
}
