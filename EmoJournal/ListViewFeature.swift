//
//  ListViewFeature.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import ComposableArchitecture
import UIKit

class JournalModel: Identifiable, Equatable {
    static func == (lhs: JournalModel, rhs: JournalModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var content: String = ""
    var imageData: Data?
    var date: Date
    var id: UUID = UUID()
    
    init(content: String, imageData: Data? = nil, date: Date, id: UUID) {
        self.content = content
        self.imageData = imageData
        self.date = date
        self.id = id
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
                return .run { send in
                    await send(.loadPersistenceInstances)
                }
            case .finishWriting(.presented(.delegate(.quitWriting))):
                return .none
            case let .finishWriting(.presented(.delegate(.saveWriting(text, image, date, id, isEditing)))):
                let value: [String: Any?] = [
                    CoreDataKey.id.rawValue: id,
                    CoreDataKey.content.rawValue: text,
                    CoreDataKey.writeDate.rawValue: date,
                    CoreDataKey.imgData.rawValue: image?.data
                ]
                if !isEditing {
                    PersistenceController.shared.save(value)
                }
                else {
                    let predicate = NSPredicate(format: "id = %@", id as CVarArg)
                    PersistenceController.shared.update(attributes: value, predicate: predicate)
                }
                return .run { send in
                    await send(.loadPersistenceInstances)
                }
            case .loadPersistenceInstances:
                let result: [WriteDataEntity] = PersistenceController.shared.fetch()
                
                var journalList: [JournalModel] = []
                
                result.forEach {
                    if let content = $0.content, let date = $0.writeDate, let id = $0.id{
                        journalList.append(JournalModel(content: content, imageData: $0.imgData, date: date, id: id))
                    }
                }
                state.list = journalList
                return .none
            case let .deleteButtonTapped(data):
                PersistenceController.shared.delete(predicate: NSPredicate(format: "id = %@", data.id as CVarArg))
                return .run { send in
                    await send(.loadPersistenceInstances)
                }
            case let .editButtonTapped(data):
                var writeState = WriteFeature.State()
                if let imageData = data.imageData {
                    let image = WriteImage(data: imageData, image: UIImage(data: imageData))
                    writeState.image = image
                }
                writeState.text = data.content
                writeState.writeDate = data.date
                writeState.id = data.id
                writeState.isEditing = true
                
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
