//
//  PhotoClient.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/23/24.
//

import ComposableArchitecture
import SwiftUI
import PhotosUI

@DependencyClient
struct PhotoClient {
    var load: @Sendable(_ item: PhotosPickerItem?) async throws -> WriteImage?
}

extension PhotoClient: DependencyKey {
    static let liveValue = Self { item in
        
        let data = try await item?.loadTransferable(type: Data.self)
        guard let imgData = data else {
            return nil
        }
        
        return WriteImage(data: imgData, image: UIImage(data: imgData))
    }
}

extension DependencyValues {
    var photoClient: PhotoClient {
        get { self[PhotoClient.self] }
        set { self[PhotoClient.self] = newValue }
    }
}
