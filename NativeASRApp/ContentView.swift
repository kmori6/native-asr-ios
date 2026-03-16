//
//  ContentView.swift
//  NativeASRApp
//
//  Created by Kosuke Mori on 2026/03/14.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack(spacing: 24) {
            headerSection
            transcriptSection
            controlSection
            errorSection
        }
        .padding(24)
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
    }
}

private extension ContentView {
    var headerSection: some View {
        VStack(spacing: 8) {
            Text("Native ASR")
                .font(.largeTitle.bold())

            Text(speechRecognizer.statusMessage)
                .foregroundStyle(.secondary)
        }
    }
    
    var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Result")
                .font(.headline)
            
            ScrollView {
                Text(speechRecognizer.transcript.isEmpty ? "Display recognition results here." : speechRecognizer.transcript)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    var controlSection: some View {
        HStack(spacing: 16) {
            Button(speechRecognizer.isRecording ? "Stop" : "Start") {
                if speechRecognizer.isRecording {
                    speechRecognizer.startRecognition()
                } else {
                    speechRecognizer.stopRecognition()
                }
            }

            Button("Clear") {
                speechRecognizer.clearTranscript()
            }
        }
    }
    
    @ViewBuilder
    var errorSection: some View {
        if speechRecognizer.errorMessage != nil {
            Text(speechRecognizer.errorMessage!)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    ContentView()
}
