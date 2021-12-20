//
//  ImageViewerSwiftUIApp.swift
//  Shared
//
//  Created by Genji on 2021/08/17.
//

import SwiftUI

@main
struct ImageViewerSwiftUIApp: App {
  var body: some Scene {
    DocumentGroup(viewing: ImageDocument.self) { file in
      ContentView(document: file.document)
        .focusedSceneValue(\.focusedSceneDocument, file.document)
    }
    .commands {
      ZoomCommands()
    }
  }
}

struct ZoomCommands: Commands {

  @FocusedValue(\.focusedSceneDocument) var document

  var body: some Commands {
    CommandGroup(after: .toolbar) {
      Button("Actual Size") {
        document?.resetViewSize(animate: true)
      }
      .keyboardShortcut(KeyEquivalent("0"))

      Button("Zoom In") {
        document?.scaleViewSize(2.0, animate: true)
      }
      .keyboardShortcut(KeyEquivalent("+"))

      Button("Zoom Out") {
        document?.scaleViewSize(0.5, animate: true)
      }
      .keyboardShortcut(KeyEquivalent("-"))

      Divider()
    }
  }
}
