# EmoJournal

EmoJournal은 SwiftUI와 TCA(Composable Architecture)를 사용하여 간단한 일기를 작성하고, 음성 인식을 통해 일기를 입력할 수 있는 일기 앱입니다. Core Data를 활용해 일기 데이터를 로컬에서 저장 및 관리하며, CRUD(Create, Read, Update, Delete) 기능을 제공합니다.

## Features

- **일기 작성**: 간단하게 텍스트 형식의 일기를 작성할 수 있습니다.
- **음성 인식**: 음성 인식을 통해 음성을 텍스트로 변환하여 일기를 입력할 수 있습니다.
- **일기 관리**: Core Data를 활용한 로컬 데이터베이스에 일기를 저장하고, 수정 및 삭제가 가능합니다.
- **TCA (The Composable Architecture)**: 앱 상태 관리 및 기능 모듈화를 위해 TCA 패턴을 적용했습니다.

## Technologies Used

- **SwiftUI**: 사용자 인터페이스를 구현하는 데 사용되었습니다.
- **TCA (Composable Architecture)**: 상태 관리와 비즈니스 로직을 구조화하는 데 사용되었습니다.
- **Core Data**: 로컬 데이터베이스를 사용하여 일기를 저장, 관리합니다.
- **Speech Framework**: 음성 인식을 통해 음성을 텍스트로 변환하는 기능을 제공합니다.
