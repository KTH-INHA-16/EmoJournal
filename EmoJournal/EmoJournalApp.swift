//
//  EmoJournalApp.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/4/24.
//

import SwiftUI

@main
struct EmoJournalApp: App {
    @AppStorage("ColorIdx") private var colorIdx = 0
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
