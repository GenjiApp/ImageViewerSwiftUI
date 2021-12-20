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
