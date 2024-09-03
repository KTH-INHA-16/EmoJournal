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
        case writeButtonTapped
        case deleteButtonTapped(JournalModel)
        case editButtonTapped(JournalModel)
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
            case let .deleteButtonTapped(data):
                PersistenceController.shared.delete(predicate: NSPredicate(format: "id = %@", data.id as CVarArg))
                
                return .send(.loadPersistenceInstances)
            case let .editButtonTapped(data):
                var writeState = WriteFeature.State()
                let image = WriteImage(data: data.imageData)
                writeState.image = image
                writeState.text = data.content
                writeState.writeDate = data.date
                
                state.finishWriting = writeState
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
