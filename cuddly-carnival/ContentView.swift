//
//  ContentView.swift
//  cuddly-carnival
//
//  Created by Türk, Florian on 23.09.22.
//

import AVFoundation
import Combine
import SwiftUI
import UserNotifications

struct ContentView: View {
    var recorder: AVAudioRecorder?
    var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    let LEVEL_THRESHOLD: Float = -10.0

    @State var leftLevel: Int = 0
    @State var rightLevel: Int = 0
    @State var decibels: Float = 0.0
    @State var buttonTitle: String = "Start"
    @State var infoTitle: String = "Press \"Start\" to start recording"
    @State var isRecording: Bool = false

    @State var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    @State private var notificationButtonIsDisabled = false

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
            try recorder = AVAudioRecorder(url: url, settings: recordSettings)
        } catch {
            return
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            Circle()
                .trim(from: 0.0, to: CGFloat(leftLevel) / 10.0)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.1f dB", self.decibels))
                .font(.largeTitle)
                .bold()
        }.padding()

        Button(buttonTitle, action: startRecording)
            .padding()

        Text(infoTitle)
        Divider()
        Button("Test Notification") {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = "Alarm!"
                    content.subtitle = "Aufwachen!"
                    content.sound = UNNotificationSound.default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    
                    UNUserNotificationCenter.current().add(request)
                } else {
                    notificationButtonIsDisabled = true
                }
            }
        }.disabled(notificationButtonIsDisabled)
    }

    private func startRecording() {
        if isRecording {
            self.recorder?.stop()
            self.isRecording = false
            self.buttonTitle = "Start"
            self.infoTitle = "Press \"Start\" to start recording"
            self.leftLevel = 0
            self.rightLevel = 0
            self.decibels = 0
            connectedTimer?.cancel()
            return
        }

        audioSession.requestRecordPermission { granted in
            if granted {
                self.infoTitle = "Starting recording ..."
                self.recorder?.prepareToRecord()
                self.recorder?.isMeteringEnabled = true
                self.recorder?.record()

                buttonTitle = "Stop"
                isRecording = true

                connectedTimer = Timer.publish(every: 0.01, on: .main, in: .default)
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
        leftLevel = level(for: recorder?.peakPower(forChannel: 0) ?? 0)
        rightLevel = level(for: recorder?.peakPower(forChannel: 1) ?? 0)
        decibels = recorder?.peakPower(forChannel: 0) ?? 0
        infoTitle = "Left: \(leftLevel) - Right: \(rightLevel)"
    }

    private func level(for decibels: Float) -> Int {
        var level: Float = 0.0
        let minDecibels: Float = -90

        if (decibels < minDecibels) {
            level = 0
        } else if (decibels >= 0) {
            level = 1
        } else {
            let root: Float = 2.0
            let minAmp = powf(10.0, 0.05 * minDecibels)
            let inverseAmpRange = 1.0 / ( 1.0 - minAmp)
            let amp = powf(10.0, 0.05 * decibels)
            let adjAmp = (amp - minAmp) * inverseAmpRange

            level = powf(adjAmp, 1.0 / root)
        }

        return Int(level * 100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
