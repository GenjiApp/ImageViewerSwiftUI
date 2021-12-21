//
//  ZoomCommands.swift
//  ImageViewerSwiftUI
//
//  Created by Genji on 2021/12/20.
//

import SwiftUI

struct ZoomCommands: Commands {

  @FocusedValue(\.focusedSceneDocument) var document

  var body: some Commands {
    CommandGroup(after: .toolbar) {
      Button("Actual Size") {
        document?.resetViewSize(animate: true)
      }
      .keyboardShortcut(KeyEquivalent("0"))
      .disabled(document == nil)

      Button("Zoom In") {
        document?.scaleViewSize(2.0, animate: true)
      }
      .keyboardShortcut(KeyEquivalent("+"))
      .disabled(document == nil)

      Button("Zoom Out") {
        document?.scaleViewSize(0.5, animate: true)
      }
      .keyboardShortcut(KeyEquivalent("-"))
      .disabled(document == nil)

      Divider()
    }
  }
}
