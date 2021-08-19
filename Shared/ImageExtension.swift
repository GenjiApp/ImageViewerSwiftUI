//
//  ImageExtension.swift
//  ImageViewerSwiftUI
//
//  Created by Genji on 2021/08/19.
//

import SwiftUI

#if os(macOS)
typealias MyImage = NSImage
#elseif os(iOS)
typealias MyImage = UIImage
#endif

extension Image {

  init(myImage: MyImage) {
    #if os(macOS)
    self.init(nsImage: myImage)
    #elseif os(iOS)
    self.init(uiImage: myImage)
    #endif
  }
}
