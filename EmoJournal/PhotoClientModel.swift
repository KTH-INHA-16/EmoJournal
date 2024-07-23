//
//  PhotoClientModel.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import SwiftUI
import PhotosUI

struct WriteImage: Identifiable, Equatable {
    let id: UUID = UUID()
    var image: UIImage? = nil
}

extension WriteImage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PhotosPickerItem: Identifiable {
    public var id: String {
        self.hashValue.description
    }
}
    