//
//  ImageDocument.swift
//  Shared
//
//  Created by Genji on 2021/08/17.
//

import SwiftUI
import UniformTypeIdentifiers

// viewSize プロパティを @Published にしたいので、ReferenceFileDocument にした。
// viewSize プロパティは拡大・縮小時の表示サイズを格納する。
class ImageDocument: ReferenceFileDocument {

  typealias Snapshot = IVImage

  static var readableContentTypes: [UTType] {
    [
      UTType(importedAs: "public.png"),
      UTType(importedAs: "public.jpeg")
    ]
  }

  var image: IVImage
  @Published var viewSize: CGSize

  init(image: IVImage = IVImage()) {
    self.image = image
    self.viewSize = image.size
  }

  required init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents,
          let image = IVImage(data: data)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    self.image = image
    self.viewSize = image.size
  }

  // 閲覧専用なので保存用メソッドは使わない。
  func fileWrapper(snapshot: IVImage, configuration: WriteConfiguration) throws -> FileWrapper {
    throw CocoaError(.fileWriteUnknown)
  }

  func snapshot(contentType: UTType) throws -> IVImage {
    return self.image
  }

  // MARK: -
  func scaleViewSize(_ scale: CGFloat) {
    self.scaleViewSize(scale, animate: false)
  }

  func scaleViewSize(_ scale: CGFloat, animate: Bool) {
    var newViewSize = CGSize(width: self.viewSize.width * scale, height: self.viewSize.height * scale)

    if newViewSize.width < self.image.size.width * 0.2 {
      newViewSize.width = self.image.size.width * 0.2
      newViewSize.height = self.image.size.height * 0.2
    }
    else if newViewSize.width > self.image.size.width * 5 {
      newViewSize.width = self.image.size.width * 5
      newViewSize.height = self.image.size.height * 5
    }

    if animate {
      withAnimation {
        self.viewSize = newViewSize
      }
    }
    else {
      self.viewSize = newViewSize
    }
  }

  func resetViewSize() {
    self.resetViewSize(animate: false)
  }

  func resetViewSize(animate: Bool) {
    if animate {
      withAnimation {
        self.viewSize = self.image.size
      }
    }
    else {
      self.viewSize = self.image.size
    }
  }

}
