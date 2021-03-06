//
//  ContentView.swift
//  Shared
//
//  Created by Genji on 2021/08/17.
//

import SwiftUI

struct ContentView: View {

  @ObservedObject var document: ImageDocument
  @GestureState private var scale: CGFloat = 1.0

  // ジェスチャ中の表示サイズ変更は .scaleEffect() で表現し、
  // ジェスチャ終了時に .frame(width:, height:) で実際の表示サイズを変更する。
  var magnificationGesture: some Gesture {
    MagnificationGesture()
      // gestureState に値を代入すると、それが @GestureState のプロパティに入る。
      // @GestureState のプロパティはジェスチャ終了時に自動的に初期値にリセットされる。
      // 急激な拡大・縮小を防ぐため、値の範囲に制限を加える。
      .updating(self.$scale) { currentValue, gestureState, _ in
        if currentValue < 0.1 {
          gestureState = 0.1
        }
        else if currentValue > 5 {
          gestureState = 5
        }
        else {
          gestureState = currentValue
        }
      }
      // ジェスチャ完了時の最終的な値が finalValue に入っている。
      // これを使って実際に表示サイズを変更する。
      // .updating() で @GestureStateに加えた制限は finalValue には
      // 適用されないので、改めて範囲制限を加える。
      .onEnded { finalValue in
        var scale = finalValue
        if scale < 0.1 {
          scale = 0.1
        }
        else if scale > 5 {
          scale = 5
        }
        self.document.scaleViewSize(scale)
      }
  }

  var body: some View {

    ScrollView([.horizontal, .vertical]) {
      Image(ivImage: document.image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        // ジェスチャ中の見掛け上の表示サイズ変更をする。
        // @GestureState なプロパティはジェスチャ終了時には初期値にリセットされる。
        .scaleEffect(self.scale)
        // ジェスチャ完了後の実際の表示サイズは .frame(width:, height:) を使う。
        // .scaleEffect() では ScrollView から見た表示サイズが変更されないので、
        // スクロールが狂う。
        .frame(width: self.document.viewSize.width,
               height: self.document.viewSize.height)
        .gesture(magnificationGesture)
        .onTapGesture(count: 2) {
          self.document.resetViewSize(animate: true)
        }
    }
    .toolbar {
      MagnifyToolbarButtons(document: self.document)
    }
  }
}

struct MagnifyToolbarButtons: ToolbarContent {

  let document: ImageDocument

  var body: some ToolbarContent {

    // iPhoneでは ToolbarItemPlacement.automatic で上部ツールバーに
    // 複数のボタンを指定しても最初のひとつしか表示されないので、.bottomBar 指定に。
    // macOSには .bottomBar がないので .automatic 指定で場合分け。
    #if os(iOS)
    let placement = ToolbarItemPlacement.bottomBar
    #else
    let placement = ToolbarItemPlacement.automatic
    #endif
    ToolbarItemGroup(placement: placement) {
      Button(action: {
        self.document.scaleViewSize(0.5, animate: true)
      }) {
        Image(systemName: "minus.magnifyingglass")
      }
      Button(action: {
        self.document.resetViewSize(animate: true)
      }) {
        Image(systemName: "equal.circle")
      }
      Button(action: {
        self.document.scaleViewSize(2.0, animate: true)
      }) {
        Image(systemName: "plus.magnifyingglass")
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(document: ImageDocument())
  }
}
