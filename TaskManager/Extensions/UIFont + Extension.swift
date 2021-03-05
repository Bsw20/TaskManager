//
//  UIFont + Extension.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import UIKit

extension UIFont {
  func withWeight(_ weight: UIFont.Weight) -> UIFont {
    let newDescriptor = fontDescriptor.addingAttributes([.traits: [
      UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: newDescriptor, size: pointSize)
  }
}
