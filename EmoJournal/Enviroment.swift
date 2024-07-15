//
//  Enviroment.swift
//  EmoJournal
//
//  Created by 김태훈 on 7/12/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct Theme {
    @AppStorage("ColorIdx") private var colorIdx: Int = 0
}


enum ThemeKey: EnvironmentKey {
  static var defaultValue: Theme { Theme() }
}

extension EnvironmentValues {
   public var theme: Theme {
    get { self[ThemeKey.self] }
    set { self[ThemeKey.self] = newValue }
  }
}
