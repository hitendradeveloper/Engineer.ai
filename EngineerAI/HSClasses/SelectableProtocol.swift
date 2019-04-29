//
//  HSIDentifiable.swift
//  HSFramework
//
//  Created by Hitendra Solanki on 10/01/18.
//  Copyright © 2018 Hitendra iDev. All rights reserved.
//
//  Hitendra: Selection Support
//  Convert your any model object in to selectable.
//  Select|Desect your model object(class type).

import Foundation

//MARK: Protocol HSSelectable
/*
 HSSelectable is the protocol that work as a 'Bone marrow' of selection logic

 */
protocol HSSelectable : class {
  var isSelected: Bool {get set}
}

//MARK: HSSelectableKeys
/*
 HSSelectableKeys to use as references
 */
struct HSSelectableKeys {
  static var isSelected : String = "HSSelectable.isSelected"
}

//MARK: HSSelectable Default Implementation
/*
 HSSelectable is the protocol that work as a 'Bone marrow' of whole logic
 Reusable logic implementation of Selection Support without modifing existing classes.
 */
extension HSSelectable {
  var isSelected: Bool {
    get{
      return (objc_getAssociatedObject(self, &HSSelectableKeys.isSelected) as? Bool) ?? false
    }
    set{
      objc_setAssociatedObject(self, &HSSelectableKeys.isSelected, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

//MARK: Retrive Selected Values
/*
 Calculated Property: Get Selected values
 */
extension Array where Element: HSSelectable {
  var selectedValues: [Element] {
    return self.filter({ (element) -> Bool in
      return element.isSelected
    })
  }
}

//MARK: Array Level Oprations
/*
 Methods: Select/Deselect All elements
 */
extension Array where Element: HSSelectable {
  func selectAll(){
    self.selectDeselectAll(select: true)
  }
  func deselectAll(){
    self.selectDeselectAll(select: false)
  }
}

//MARK: Element Level Oprations
/*
 Methods: Select/Deselect perticuler element
 */
extension Array where Element: HSSelectable {
  func select(at index: Int){
    self.selectDeselect(at: index, canSelect: true)
  }
  func deselect(at index: Int){
    self.selectDeselect(at: index, canSelect: false)
  }
}


//MARK: Private method implementation
/*
 Methods: Private methods to support above operations
 */
extension Array where Element: HSSelectable {
  private func selectDeselectAll(select: Bool){
    self.forEach { (element) in
      element.isSelected = select
    }
  }
  private func selectDeselect(at index: Int, canSelect: Bool){
    let element = self[index]
    element.isSelected = canSelect
  }
}
