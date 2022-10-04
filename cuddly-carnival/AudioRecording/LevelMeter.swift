import AVFoundation
import Combine
import SwiftUI

class LevelMeter: ObservableObject {
    @Published var level: Double = 0
    @Published var isMetering = false
    @Published var accessGranted = false

    private var connectedTimer: Cancellable? = nil
    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var timer: Timer.TimerPublisher = Timer.publish(every: 0.02, on: .main, in: .common)

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

    func start() {
        audioSession.requestRecordPermission { [weak self] granted in
            self?.accessGranted = granted
            if granted {
                self?.recorder?.prepareToRecord()
                self?.recorder?.isMeteringEnabled = true
                self?.recorder?.record()

                self?.isMetering = true

                self?.connectedTimer = Timer.publish(every: 0.01, on: .main, in: .default)
                    .autoconnect()
                    .sink { _ in
                        self?.levelTimerCallback()
                    }
            }
        }
    }

    func stop() {
        level = 0
        isMetering = false
        connectedTimer?.cancel()
        recorder?.stop()
    }

    private func levelTimerCallback() {
        recorder?.updateMeters()
        level = level(
            for: (
                (recorder?.peakPower(forChannel: 0) ?? 0)
                +
                (recorder?.peakPower(forChannel: 1) ?? 0)
            )
        )
    }

    private func level(for decibels: Float) -> Double {
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

        return Double(level * 100)
    }
}
