//
//  ImageExtension.swift
//  ImageViewerSwiftUI
//
//  Created by Genji on 2021/08/19.
//

import SwiftUI

#if os(macOS)
typealias IVImage = NSImage
#elseif os(iOS)
typealias IVImage = UIImage
#endif

extension Image {

  init(ivImage: IVImage) {
    #if os(macOS)
    self.init(nsImage: ivImage)
    #elseif os(iOS)
    self.init(uiImage: ivImage)
    #endif
  }
}
