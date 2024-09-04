//
//  WriteFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/22/24.
//

import ComposableArchitecture
import Speech
import PhotosUI
import SwiftUI

@Reducer
struct WriteFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var cursorPoint = 0
        var isRecording = false
        var isAnimate = false
        var text = ""
        var writeDate = Date()
        var image: WriteImage? = nil
        var avatarItem: PhotosPickerItem? = nil
        var id = UUID()
        var isEditing = false
    }
    
    enum Action {
        case textChanged(String)
        case cursorChange(Int)
        case alert(PresentationAction<Alert>)
        case cancelButtonTapped
        case saveButtonTapped
        case photoCancelButtonTapped
        case recordButtonTapped
        case datePickerTapped(Date)
        case speech(Result<String, Error>)
        case speechRecognizerAuthorizationStatusResponse(SFSpeechRecognizerAuthorizationStatus)
        case photoLibraryButtonTapped(PhotosPickerItem?)
        case photoLibrary(WriteImage?)
        case delegate(Delegate)
        
        enum Alert: Equatable {}
        
        enum Delegate: Equatable {
            case quitWriting
            case saveWriting(String, WriteImage?, Date, UUID, Bool)
        }
    }
    
    @Dependency(\.photoClient) var photoClient
    @Dependency(\.speechClient) var speechClient
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert:
                return .none
                
            case .cancelButtonTapped:
                return .run { send in
                    await send(.delegate(.quitWriting))
                    await self.dismiss()
                }
                
            case .saveButtonTapped:
                return .run { [state = state] send in
                    await send(.delegate(.saveWriting(state.text, state.image, state.writeDate, state.id, state.isEditing)))
                    await self.dismiss()
                }
                
            case .photoCancelButtonTapped:
                state.avatarItem = nil
                state.image = nil
                state.isAnimate = false
                return .none
                
            case let .datePickerTapped(date):
                state.writeDate = date
                return .none
                
            case let .photoLibrary(image):
                state.image = image
                state.isAnimate = true
                return .none
                
            case let .textChanged(text):
                state.text = text
                return .none
                
            case let .cursorChange(cursorPoint):
                state.cursorPoint = cursorPoint
                
                return .none
                
            case let .photoLibraryButtonTapped(avatarItem):
                state.avatarItem = avatarItem
                
                return .run(priority: .low, operation: { [avatarItem = state.avatarItem] send in
                    let data = try await self.photoClient.load(item: avatarItem)
                    
                    await send(.photoLibrary(data))
                    
                }, catch: { error, send in
                    await send(.speech(.failure(error)))
                })
            
            case .recordButtonTapped:
                state.isRecording.toggle()
                guard state.isRecording else {
                    return .run { _ in
                        await self.speechClient.finishTask()
                    }
                }
                
                return .run { send in
                    let status = await self.speechClient.requestAuthorization()
                    
                    await send(.speechRecognizerAuthorizationStatusResponse(status))
                    
                    guard status == .authorized else {
                        return
                    }
                    
                    let request = SFSpeechAudioBufferRecognitionRequest()
                    for try await result in await self.speechClient.startTask(request) {
                        await send(.speech(.success(result.bestTranscription.formattedString)), animation: .linear)
                    }
                } catch: { error, send in
                    await send(.speech(.failure(error)))
                }
                
            case .speech(.failure(SpeechClient.Failure.couldntConfigureAudioSession)), .speech(.failure(SpeechClient.Failure.couldntStartAudioEngine)):
                state.alert = AlertState {
                    TextState("기기에 오디오 문제가 있습니다. 다시 시도해주세요.")
                }
                return .none
                
            case .speech(.failure):
                state.alert = AlertState {
                    TextState("받아쓰기 중 오류가 발생했습니다. 다시 시도해주세요")
                }
                return .none
            
            case let .speech(.success(transcribedText)):
                let index = state.text.index(state.text.startIndex, offsetBy: state.cursorPoint)
                
                state.text.insert(contentsOf: transcribedText, at: index)
                state.cursorPoint += transcribedText.count
                
                return .none
                
            case let .speechRecognizerAuthorizationStatusResponse(status):
                state.isRecording = status == .authorized
                
                switch status {
                case .authorized:
                    return .none
                
                case .denied:
                    state.alert = AlertState {
                        TextState(
                        """
                        음성 인식 서비스에 접근 할 수 없습니다.
                        앱의 설정에서 권한을 확인해주세요.
                        """
                        )
                    }
                    
                    return .none
                    
                case .restricted:
                    state.alert = AlertState { TextState("기기에서 음성인식을 지원하지 않습니다.") }
                    return .none
                    
                case .notDetermined:
                    return .none
                    
                @unknown default:
                    return .none
                }
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}
