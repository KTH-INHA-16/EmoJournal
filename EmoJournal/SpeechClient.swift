//
//  SpeechClient.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/19/24.
//

import ComposableArchitecture
import Speech

@DependencyClient
struct SpeechClient {
    var finishTask: @Sendable () async -> Void
    var requestAuthorization: @Sendable () async -> SFSpeechRecognizerAuthorizationStatus = {
        .notDetermined
    }
    var startTask:
    @Sendable (_ request: SFSpeechAudioBufferRecognitionRequest) async -> AsyncThrowingStream<
        SpeechRecognitionResult, Error
    > = { _ in .finished() }
    
    enum Failure: Error, Equatable {
        case taskError
        case couldntStartAudioEngine
        case couldntConfigureAudioSession
    }
}

extension SpeechClient: TestDependencyKey {
    static var previewValue: Self {
        let isRecording = LockIsolated(false)
        
        return Self(
            finishTask: { await isRecording.setValue(false) },
            requestAuthorization: { .authorized },
            startTask: { _ in
                AsyncThrowingStream { continuation in
                    Task {
                        isRecording.setValue(true)
                        var finalText = """
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
              incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
              exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute \
              irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla \
              pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui \
              officia deserunt mollit anim id est laborum.
              """
                        var text = ""
                        while isRecording.value {
                            let word = finalText.prefix { $0 != " " }
                            try await Task.sleep(for: .milliseconds(word.count * 50 + .random(in: 0...200)))
                            finalText.removeFirst(word.count)
                            if finalText.first == " " {
                                finalText.removeFirst()
                            }
                            text += word + " "
                            continuation.yield(
                                SpeechRecognitionResult(
                                    bestTranscription: Transcription(
                                        formattedString: text,
                                        segments: []
                                    ),
                                    isFinal: false,
                                    transcriptions: []
                                )
                            )
                        }
                    }
                }
            }
        )
    }
    
    static let testValue = Self()
}

extension SpeechClient: DependencyKey {
    static var liveValue: Self {
        let speech = Speech()
        return Self(
            finishTask: {
                await speech.finishTask()
            },
            requestAuthorization: {
                await withCheckedContinuation { continuation in
                    SFSpeechRecognizer.requestAuthorization { status in
                        continuation.resume(returning: status)
                    }
                }
            },
            startTask: { request in
                let request = UncheckedSendable(request)
                return await speech.startTask(request: request)
            }
        )
    }
}

private actor Speech {
    var audioEngine: AVAudioEngine? = nil
    var recognitionTask: SFSpeechRecognitionTask? = nil
    var recognitionContinuation: AsyncThrowingStream<SpeechRecognitionResult, Error>.Continuation?
    
    func finishTask() {
        self.audioEngine?.stop()
        self.audioEngine?.inputNode.removeTap(onBus: 0)
        self.recognitionTask?.finish()
        self.recognitionContinuation?.finish()
    }
    
    func startTask(request: UncheckedSendable<SFSpeechAudioBufferRecognitionRequest>) -> AsyncThrowingStream<SpeechRecognitionResult, Error> {
        let request = request.wrappedValue
        
        return AsyncThrowingStream { continuation in
            self.recognitionContinuation = continuation
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                continuation.finish(throwing: SpeechClient.Failure.couldntConfigureAudioSession)
                return
            }
            
            self.audioEngine = AVAudioEngine()
            let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)!
            self.recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
                switch (result, error) {
                case let (.some(result), _):
                    continuation.yield(SpeechRecognitionResult(result))
                case (_, .some):
                    continuation.finish(throwing: SpeechClient.Failure.taskError)
                case (.none, .none):
                    fatalError("It should not be possible to have both a nil result and nil error.")
                }
            }
            
            continuation.onTermination = {
                [
                    speechRecognizer = UncheckedSendable(speechRecognizer),
                    audioEngine = UncheckedSendable(audioEngine),
                    recognitionTask = UncheckedSendable(recognitionTask)
                ]
                _ in
                
                _ = speechRecognizer
                audioEngine.wrappedValue?.stop()
                audioEngine.wrappedValue?.inputNode.removeTap(onBus: 0)
                recognitionTask.wrappedValue?.finish()
            }
            
            self.audioEngine?.inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: self.audioEngine?.inputNode.outputFormat(forBus: 0)
            ) { buffer, when in
                request.append(buffer)
            }
            
            self.audioEngine?.prepare()
            do {
                try self.audioEngine?.start()
            } catch {
                continuation.finish(throwing: SpeechClient.Failure.couldntStartAudioEngine)
                return
            }
        }
    }
}

extension DependencyValues {
    var speechClient: SpeechClient {
        get { self[SpeechClient.self] }
        set { self[SpeechClient.self] = newValue }
    }
}
