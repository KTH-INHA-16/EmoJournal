//
//  BackgroundFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/10/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BackgroundFeature {
    @ObservableState
    struct State {
        @Presents var finishSetting: SelectFeature.State?
        @Shared(.appStorage("idx")) var idx: Int = 0
        var progress: Double = 0.0
    }
    
    enum Action {
        case settingButtonTapped
        case finishSetting(PresentationAction<SelectFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .settingButtonTapped:
                state.finishSetting = SelectFeature.State()
                return .none
            case let .finishSetting(.presented(.delegate(.saveSetting(idx)))):
                state.idx = idx
                return .none
                
            case .finishSetting:
                return .none
            }
        }
        .ifLet(\.$finishSetting, action: \.finishSetting) {
            SelectFeature()
        }
    }
}
