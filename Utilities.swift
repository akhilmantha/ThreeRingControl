//
//  Utilities.swift
//  Phonercise
//
//  Created by akhil mantha on 14/06/17.
//  Copyright © 2017 akhil mantha. All rights reserved.

import UIKit

extension UIColor {
  var darkerColor : UIColor {
    var hue : CGFloat = 0.0
    var saturation : CGFloat = 0.0
    var brightness : CGFloat = 0.0
    var alpha : CGFloat = 0.0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return UIColor(hue: min(hue * 1.1, 1.0), saturation: saturation, brightness: brightness * 0.7, alpha: alpha)
  }
}

extension CGColor {
  var darkerColor : CGColor {
    let uiColor = UIColor(cgColor: self)
    return uiColor.darkerColor.cgColor
  }
}

extension CALayer {
  var center : CGPoint {
    return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
  }
}



extension UIColor {
  static var hrGreenColor : UIColor {
    return UIColor(red: 158.0/255.0, green: 255.0/255.0, blue:   9.0/255.0, alpha: 1.0)
  }
  
  static var hrBlueColor : UIColor {
    return UIColor(red:  33.0/255.0, green: 253.0/255.0, blue: 197.0/255.0, alpha: 1.0)
  }
  
  static var hrPinkColor : UIColor {
    return UIColor(red: 251.0/255.0, green:  12.0/255.0, blue: 116.0/255.0, alpha: 1.0)
  }
}


func rotationForLayer(_ layer: CALayer, byAngle angle: CGFloat) -> CAKeyframeAnimation {
  let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
  
  let c = layer.value(forKeyPath: "transform.rotation.z")
  let currentAngle = c as? CGFloat ?? 0
  
  let numberOfKeyFrames = Int(floor(abs(angle) / CGFloat(M_PI_4)) + 2)
  
  var times = [CGFloat]()
  var values = [CGFloat]()
  
  for i in 0 ... abs(numberOfKeyFrames) {
    times.append(CGFloat(i) / CGFloat(numberOfKeyFrames))
    values.append(angle / CGFloat(numberOfKeyFrames) * CGFloat(i) + currentAngle)
  }
  
  animation.keyTimes = times as [NSNumber]?
  animation.values = values
  
  return animation
}
