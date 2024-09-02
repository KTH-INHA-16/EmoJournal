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
        case deleteButtonTapped
        case editButtonTapped
        case delete(Delegate)
        
        enum Delegate: Equatable {
            case deleteData
            case editData(JournalModel)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTapped:
                PersistenceController.shared.delete(predicate: NSPredicate(format: "id = %@", state.data.id as CVarArg))
                
                return .send(.delete(.deleteData))
            case .editButtonTapped:
                return .send(.delete(.editData(state.data)))
            case .delete:
                return .none

            }
        }
    }
    
}
