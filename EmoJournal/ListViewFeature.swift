//
//  ListViewFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import ComposableArchitecture
import Foundation

class JournalModel {
    var content: String = ""
    var imageData: Data?
    var date: Date
    
    init(content: String, imageData: Data? = nil, date: Date) {
        self.content = content
        self.imageData = imageData
        self.date = date
    }
}

@Reducer
struct ListViewFeature {
    @ObservableState
    struct State {
        @Presents var finishWriting: WriteFeature.State?
        var list: [JournalModel] = []
    }
    
    enum Action {
        case finishWriting(PresentationAction<WriteFeature.Action>)
        case writeButtonTapped
        case loadPersistenceInstances
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
                let value: [String: Any?] = [
                    CoreDataKey.content.rawValue: text,
                    CoreDataKey.writeDate.rawValue: date,
                    CoreDataKey.imgData.rawValue: image?.data
                ]
                PersistenceController.shared.save(value)
                return .run { send in
                    await send(.loadPersistenceInstances)
                }
            case .loadPersistenceInstances:
                let result: [WriteDataEntity] = PersistenceController.shared.fetch()
                
                var journalList: [JournalModel] = []
                
                result.forEach {
                    if let content = $0.content,
                       let date = $0.writeDate {
                        
                        journalList.append(JournalModel(content: content, imageData: $0.imgData, date: date))
                    }
                }
                    
                state.list = journalList
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
