//
//  ThreeRingView.swift
//  Phonercise
//
//  Created by akhil mantha on 14/06/17.
//  Copyright © 2017 akhil mantha. All rights reserved.


import UIKit

enum RingIndex : Int {
  case inner  = 0
  case middle = 1
  case outer  = 2
}

let RingCompletedNotification = "RingCompletedNotification"
let AllRingsCompletedNotification = "AllRingsCompletedNotification"

@IBDesignable
class ThreeRingView : UIView {
  
  fileprivate let rings : [RingIndex : RingLayer] = [.inner : RingLayer(), .middle : RingLayer(), .outer : RingLayer()]
  fileprivate let ringColors = [UIColor.hrPinkColor, UIColor.hrGreenColor, UIColor.hrBlueColor]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInitialization()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInitialization()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    drawLayers()
  }
  
  
  fileprivate func sharedInitialization() {
    backgroundColor = UIColor.black
    for (_, ring) in rings {
      layer.addSublayer(ring)
      ring.backgroundColor = UIColor.clear.cgColor
      ring.ringBackgroundColor = ringBackgroundColor.cgColor
      ring.ringWidth = ringWidth
    }
    
    // Set the default values
    for (index, ring) in rings {
        setColorForRing(index, color: ringColors[index.rawValue])
        ring.value = 0.0
    }
  }
  
  fileprivate func drawLayers() {
    let size = min(bounds.width, bounds.height)
    let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    for (index, ring) in rings {
      // Sort sizes
      let curSize = size - CGFloat(index.rawValue) * ( ringWidth + ringPadding ) * 2.0
      ring.bounds = CGRect(x: 0, y: 0, width: curSize, height: curSize)
      ring.position = center
    }
  }
  
  //: API Properties
  @IBInspectable
  var ringWidth : CGFloat = 20.0 {
    didSet {
      drawLayers()
      for (_, ring) in rings {
        ring.ringWidth = ringWidth
      }
    }
  }
  @IBInspectable
  var ringPadding : CGFloat = 1.0 {
    didSet {
      drawLayers()
    }
  }
  @IBInspectable
  var ringBackgroundColor : UIColor = UIColor.darkGray {
    didSet {
      for (_, ring) in rings {
        ring.ringBackgroundColor = ringBackgroundColor.cgColor
      }
    }
  }
  
  var animationDuration : TimeInterval = 1.5
}

//: Values
extension ThreeRingView {
  @IBInspectable
  var innerRingValue : CGFloat {
    get {
      return rings[.inner]?.value ?? 0
    }
    set(newValue) {
      maybePostNotification(innerRingValue, new: newValue, current: .inner)
      setValueOnRing(.inner, value: newValue, animated: false)
    }
  }
  @IBInspectable
  var middleRingValue : CGFloat {
    get {
      return rings[.middle]?.value ?? 0
    }
    set(newValue) {
      maybePostNotification(middleRingValue, new: newValue, current: .middle)
      setValueOnRing(.middle, value: newValue, animated: false)
    }
  }
  @IBInspectable
  var outerRingValue : CGFloat {
    get {
      return rings[.outer]?.value ?? 0
    }
    set(newValue) {
      maybePostNotification(outerRingValue, new: newValue, current: .outer)
      setValueOnRing(.outer, value: newValue, animated: false)
    }
  }
  func setValueOnRing(_ ringIndex: RingIndex, value: CGFloat, animated: Bool = false) {
    CATransaction.begin()
    CATransaction.setAnimationDuration(animationDuration)
    rings[ringIndex]?.setValue(value, animated: animated)
    CATransaction.commit()
  }
  
  fileprivate func maybePostNotification(_ old: CGFloat, new: CGFloat, current: RingIndex) {
    if old < 1 && new >= 1 { //threshold crossed
      let allDone: Bool
      switch(current) {
      case .inner:
        allDone = outerRingValue >= 1 && middleRingValue >= 1
      case .middle:
        allDone = innerRingValue >= 1 && outerRingValue >= 1
      case .outer:
        allDone = innerRingValue >= 1 && middleRingValue >= 1
      }
      if allDone {
        postAllRingsCompletedNotification()
      } else {
        postRingCompletedNotification()
      }
    }
  }
  
  fileprivate func postAllRingsCompletedNotification() {
    NotificationCenter.default.post(name: Notification.Name(rawValue: AllRingsCompletedNotification), object: self)
  }
  fileprivate func postRingCompletedNotification() {
    NotificationCenter.default.post(name: Notification.Name(rawValue: RingCompletedNotification), object: self)
  }
}

//: Colors
extension ThreeRingView {
  @IBInspectable
  var innerRingColor : UIColor {
    get {
      return colorForRing(.inner)
    }
    set(newColor) {
      setColorForRing(.inner, color: newColor)
    }
  }
  @IBInspectable
  var middleRingColor : UIColor {
    get {
      return UIColor.clear
    }
    set(newColor) {
      setColorForRing(.middle, color: newColor)
    }
  }
  @IBInspectable
  var outerRingColor : UIColor {
    get {
      return UIColor.clear
    }
    set(newColor) {
      setColorForRing(.outer, color: newColor)
    }
  }
  
  fileprivate func colorForRing(_ index: RingIndex) -> UIColor {
    return UIColor(cgColor: rings[index]!.ringColors.0)
  }
  
  fileprivate func setColorForRing(_ index: RingIndex, color: UIColor) {
    rings[index]?.ringColors = (color.cgColor, color.darkerColor.cgColor)
  }
}
