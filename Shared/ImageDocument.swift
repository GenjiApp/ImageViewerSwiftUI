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

  typealias Snapshot = MyImage

  static var readableContentTypes: [UTType] {
    [
      UTType(importedAs: "public.png"),
      UTType(importedAs: "public.jpeg")
    ]
  }

  var image: MyImage
  @Published var viewSize: CGSize

  init(image: MyImage = MyImage()) {
    self.image = image
    self.viewSize = image.size
  }

  required init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents,
          let image = MyImage(data: data)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    self.image = image
    self.viewSize = image.size
  }

  // 閲覧専用なので保存用メソッドは使わない。
  func fileWrapper(snapshot: MyImage, configuration: WriteConfiguration) throws -> FileWrapper {
    throw CocoaError(.fileWriteUnknown)
  }

  func snapshot(contentType: UTType) throws -> MyImage {
    return self.image
  }

  // MARK: -
  func scaleViewSize(_ scale: CGFloat) {
    self.scaleViewSize(scale, animate: false)
  }

  func scaleViewSize(_ scale: CGFloat, animate: Bool) {
    let newViewSize = CGSize(width: self.viewSize.width * scale, height: self.viewSize.height * scale)
    // 元のサイズの0.2倍以下、および5倍以上の場合は補正
    if newViewSize.width < self.image.size.width * 0.2 {
      self.scaleViewSize(scale * 1.1)
    }
    else if newViewSize.width > self.image.size.width * 5 {
      self.scaleViewSize(scale / 1.1)
    }
    else {
      if animate {
        withAnimation {
          self.viewSize = newViewSize
        }
      }
      else {
        self.viewSize = newViewSize
      }
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
