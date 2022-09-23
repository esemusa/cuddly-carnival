//
//  ContentView.swift
//  cuddly-carnival
//
//  Created by Türk, Florian on 23.09.22.
//

import AVFoundation
import Combine
import SwiftUI

struct ContentView: View {
    var recorder: AVAudioRecorder?
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    let LEVEL_THRESHOLD: Float = -10.0

    @State var level: Float = 0
    @State var buttonTitle: String = "Start"
    @State var infoTitle: String = "Press start to start recording"
    @State var isRecording: Bool = false

    @State var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil

    init() {
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")

        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]

        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
        } catch {
            return
        }
    }

    var body: some View {
        Spacer()
        Button(buttonTitle, action: startRecording)
        Spacer()
        Text(infoTitle)
    }

    private func startRecording() {
        if isRecording {
            self.recorder?.stop()
            self.isRecording = false
            self.buttonTitle = "Start"
            connectedTimer?.cancel()
            return
        }

        audioSession.requestRecordPermission { granted in
            if granted {
                self.recorder?.prepareToRecord()
                self.recorder?.isMeteringEnabled = true
                self.recorder?.record()

                buttonTitle = "Stop"
                isRecording = true

                connectedTimer = Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        levelTimerCallback()
                    }
            } else {
                infoTitle = "Failed Permission Record!"
            }
        }
    }

    private func levelTimerCallback() {
        recorder?.updateMeters()
        level = recorder?.averagePower(forChannel: 0) ?? 0
        infoTitle = "Current Level: \(level)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
