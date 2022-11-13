import AVFoundation
import Combine
import SwiftUI

class LevelMeter: ObservableObject {

    enum State {
        case active
        case inactive
        case permissionMissing
    }

    @Published var level: Int = 0
    @Published var state: State = .inactive

    private var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
    private var timer: Timer?

    init() {
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")

        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      1,
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
            if granted {
                self?.recorder?.prepareToRecord()
                self?.recorder?.isMeteringEnabled = true
                self?.recorder?.record()

                self?.state = .active

                self?.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                    self?.levelTimerCallback()
                }
            } else {
                self?.state = .permissionMissing
            }
        }
    }

    func stop() {
        level = 0
        state = .inactive
        timer?.invalidate()
        recorder?.stop()
    }

    private func levelTimerCallback() {
        recorder?.updateMeters()
        level = level(
            for: (
                (recorder?.peakPower(forChannel: 0) ?? 0)
            )
        )
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

        return Int(level * 10)
    }
}
