//
//  ListViewFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ListViewFeature {
    @ObservableState
    struct State {
        @Presents var finishWriting: WriteFeature.State?
    }
    
    enum Action {
        case finishWriting(PresentationAction<WriteFeature.Action>)
        case writeButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .writeButtonTapped:
                state.finishWriting = WriteFeature.State()
                return .none
            case .finishWriting(.presented(.delegate(.quitWriting))):
                return .none
            case let .finishWriting(.presented(.delegate(.saveWriting(text, image, date)))):
                print(text, image, date)
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$finishWriting, action: \.finishWriting) {
            WriteFeature()
        }
    }
}
