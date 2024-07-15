//
//  SelectFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/10/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SelectFeature {
    @ObservableState
    struct State: Equatable {
        var idx = 0
    }
    
    enum Action {
        case tappedColorIdx(Int)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case saveSetting(Int)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tappedColorIdx(idx):
                state.idx = idx
                return .run { [idx = state.idx] send in
                    await send(.delegate(.saveSetting(idx)))
                    await self.dismiss()
                }
                
            case .delegate:
                return .none
            }
        }
    }
}
