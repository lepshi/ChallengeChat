//
//  VoiceService.swift
//  ChallengeChat
//
//  Created by Dzmitry Pats on 2.07.23.
//

import Foundation
import Speech
import Accelerate

class VoiceService: NSObject, ObservableObject {
    @Published private(set) var isRecogniseSpeech: Bool = false
    @Published private(set) var voiceText: String = MessagesText.speechRecognizerVoicePlaceholder.rawValue
    @Published private(set) var isSpeechRecognizerAvailable: Bool = false
    @Published private(set) var levelOfMic: String = ""
    @Published public var soundSamples: [CGFloat] = [CGFloat](repeating: -72.9, count: VoiceService.numberOfSamples)
    private var currentSample: Int = 0
    static let numberOfSamples: Int = 50

    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    private var averagePowerForChannel0: Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.levelOfMic = "\(self.averagePowerForChannel0)"
                self.soundSamples.removeFirst()
                let power = self.normalizeSoundLevel(level: self.averagePowerForChannel0)
                self.soundSamples.append(power)
            }
        }
    }
    private var averagePowerForChannel1: Float = 0
    let LEVEL_LOWPASS_TRIG:Float32 = 0.30
    
    func setupSpeech() {
        self.speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isAvailable = false

            switch authStatus {
            case .authorized:
                isAvailable = true

            case .denied:
                isAvailable = false
                print("User denied access to speech recognition")

            case .restricted:
                isAvailable = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isAvailable = false
                print("Speech recognition not yet authorized")
            @unknown default:
                isAvailable = false
                print("Speech recognition not yet authorized")
            }

            OperationQueue.main.addOperation() {
                self.isSpeechRecognizerAvailable = isAvailable
            }
        }
    }
    
    func togleSpeechToText() {
        if audioEngine.isRunning {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
            isRecogniseSpeech = false
        }

        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            isRecogniseSpeech = false
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
            guard let self = self else { return }

            var isFinal = false

            if result != nil {

                if let str = result?.bestTranscription.formattedString, str.count > 0 {
                    self.voiceText = str
                }
                else {
                    self.voiceText = MessagesText.speechRecognizerVoicePlaceholder.rawValue
                }
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {

                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
            self.audioMetering(buffer: buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
            isRecogniseSpeech = true
        } catch {
            print("audioEngine couldn't start because of an error.")
            isRecogniseSpeech = false
        }
    }
            
    func stopRecording() {
        isRecogniseSpeech = false
        audioEngine.stop()
        recognitionRequest?.endAudio()
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
        
    func clearVoiceText() {
        self.voiceText = MessagesText.speechRecognizerVoicePlaceholder.rawValue
    }
    
    private func audioMetering(buffer:AVAudioPCMBuffer) {
        buffer.frameLength = 1024
        let inNumberFrames:UInt = UInt(buffer.frameLength)
        if buffer.format.channelCount > 0 {
            let samples = (buffer.floatChannelData![0])
            var avgValue:Float32 = 0
            vDSP_meamgv(samples,1 , &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel0 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel0)
            self.averagePowerForChannel1 = self.averagePowerForChannel0
        }
        
        if buffer.format.channelCount > 1 {
            let samples = buffer.floatChannelData![1]
            var avgValue:Float32 = 0
            vDSP_meamgv(samples, 1, &avgValue, inNumberFrames)
            var v:Float = -100
            if avgValue != 0 {
                v = 20.0 * log10f(avgValue)
            }
            self.averagePowerForChannel1 = (self.LEVEL_LOWPASS_TRIG*v) + ((1-self.LEVEL_LOWPASS_TRIG)*self.averagePowerForChannel1)
        }
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(1, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (39 / 25)) // scaled to max at 300 (our height of our bar)
    }
}

extension VoiceService: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        isSpeechRecognizerAvailable = available
    }
}
