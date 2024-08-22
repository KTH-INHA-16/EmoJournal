//
//  ListDetailFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ListDetailFeature {
    
    @ObservableState
    struct State {
        var data: JournalModel = JournalModel(content: "", date: Date())
    }
    
    enum Action {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
    
}
