//
//  FocusedSceneDocument.swift
//  ImageViewerSwiftUI
//
//  Created by Genji on 2021/12/20.
//

import SwiftUI

struct FocusedSceneDocumentKey: FocusedValueKey {
  typealias Value = ImageDocument
}

extension FocusedValues {
  var focusedSceneDocument: ImageDocument? {
    get { self[FocusedSceneDocumentKey.self] }
    set { self[FocusedSceneDocumentKey.self] = newValue }
  }
}
