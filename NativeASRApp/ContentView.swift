//
//  ContentView.swift
//  NativeASRApp
//
//  Created by Kosuke Mori on 2026/03/14.
//

import SwiftUI

struct ContentView: View {
    @State private var transcript: String = ""
    @State private var isRecording: Bool = false
    @State private var statusMessage: String = "waiting"
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing: 24) {
            headerSection
            transcriptSection
            controlSection
            errorSection
        }
        .padding(24)
    }
}

private extension ContentView {
    var headerSection: some View {
        VStack(spacing: 8) {
            Text("Native ASR")
                .font(.largeTitle.bold())

            Text(statusMessage)
                .foregroundStyle(.secondary)
        }
    }
    
    var transcriptSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Result")
                .font(.headline)
            
            ScrollView {
                Text(transcript.isEmpty ? "Display recognition results here." : transcript)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    var controlSection: some View {
        HStack(spacing: 16) {
            Button(isRecording ? "Stop" : "Start") {
                
            }

            Button("Clear") {
                
            }
        }
    }
    
    @ViewBuilder
    var errorSection: some View {
        if let errorMessage {
            Text(errorMessage)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    ContentView()
}
