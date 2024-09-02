//
//  ListViewFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import ComposableArchitecture
import Foundation

class JournalModel: Identifiable, Equatable {
    static func == (lhs: JournalModel, rhs: JournalModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var content: String = ""
    var imageData: Data?
    var date: Date
    var id: UUID = UUID()
    
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
        case menuButtonTouched(PresentationAction<ListDetailFeature.Action>)
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
                    CoreDataKey.id.rawValue: UUID(),
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
            case .menuButtonTouched(.presented(.delete(.deleteData))):
                return .send(.loadPersistenceInstances)
            case let .menuButtonTouched(.presented(.delete(.editData(data)))):
                // MARK: 쓰기 화면 열리면서 데이터 넘겨주기
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
