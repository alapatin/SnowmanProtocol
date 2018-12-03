//
//  Snowman.swift
//  SnowmanProtocol
//
//  Created by macbook air on 03/12/2018.
//  Copyright © 2018 alex. All rights reserved.
//

import UIKit
//@IBDesignable
class Snowman: UIView {
    
    //    @IBInspectable var scale: CGFloat = 0.95
    //    @IBInspectable var isEyesClosed: Bool = true
    //    @IBInspectable var mood: Float = 1
    //    @IBInspectable var leftArmAngle: CGFloat = 2
    //    @IBInspectable var rightArmAngle: CGFloat = 2
    //    @IBInspectable var fingerAngle: CGFloat = 2
    //    @IBInspectable var step: Int = 0
    
    
    
    var scale: CGFloat = 0.95
    static var isEyesClosed: Bool = true
    static var mood: Float = 1
    static var leftArmAngle: CGFloat = 2
    static var rightArmAngle: CGFloat = 2
    var fingerAngle: CGFloat = 2
    static var step: Int = 0
    
    
    
    enum Eye {
        case left,right
    }
    
    private struct Constants {
        static let hedRadiusToEyeOffset: CGFloat = 3
        static let headRadiusToEyeRadius: CGFloat = 10
        
        static let headRadiusToMouseOffset: CGFloat = 8
        static let headRadiusToMouthWidth: CGFloat = 3
        static let headRadiuseToMouthHeight: CGFloat = 3
        
        static let secondRadiusToArmOffset: CGFloat = 1.5
        static let headRadiusToArmLenghth: CGFloat = 0.5
        static let armLenghthToFingerLenghth: CGFloat = 5
        
        static let headRadiusToNoseLenghth: CGFloat = 2
        
        static let secondRadiusToLegOffset: CGFloat = 1.5
        static let secondRadiusToLegRadius: CGFloat = 2
    }
    
    
    
    // SNOWMAN BODY
    //-------------------------------------------------------
    private var height: CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    private var firstCircleRadius: CGFloat {
        return height / 5 * scale
    }
    
    private var secondCircleRadius: CGFloat {
        return height / 7 * scale
    }
    
    private var headCircleRadius: CGFloat {
        return height / 10 * scale
    }
    
    private var firstCircleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY + headCircleRadius + firstCircleRadius)
    }
    
    private var secondCircleCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY + headCircleRadius - secondCircleRadius)
    }
    
    private var headCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY - 2*secondCircleRadius)
    }
    
    private func pathForFirstCircle() -> UIBezierPath {
        let firstCirclePath = UIBezierPath(arcCenter: firstCircleCenter, radius: firstCircleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        firstCirclePath.lineWidth = 5.0
        return firstCirclePath
    }
    
    private func pathForSecondtCircle() -> UIBezierPath {
        let secondCirclePath = UIBezierPath(arcCenter: secondCircleCenter, radius: secondCircleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        secondCirclePath.lineWidth = 5.0
        return secondCirclePath
        
    }
    
    private func pathForHead() -> UIBezierPath {
        let headPath = UIBezierPath(arcCenter: headCenter, radius: headCircleRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        
        headPath.lineWidth = 5.0
        return headPath
    }
    //-------------------------------------------------------
    
    // EYES
    //-------------------------------------------------------
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = headCircleRadius / Constants.hedRadiusToEyeOffset
            var eyeCenter = headCenter
            eyeCenter.y -= eyeOffset
            eyeCenter.x += (eye == .left ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = headCircleRadius / Constants.headRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        var eyePath = UIBezierPath()
        
        if Snowman.isEyesClosed {
            eyePath.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            eyePath.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            return eyePath
        }
        
        eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        return eyePath
    }
    //-------------------------------------------------------
    
    // MOUTH
    //-------------------------------------------------------
    
    private func pathForMouth() ->UIBezierPath {
        
        let mouthWidth = headCircleRadius / Constants.headRadiusToMouthWidth
        let mouthHeight = headCircleRadius / Constants.headRadiuseToMouthHeight
        let mouthOffset = headCircleRadius / Constants.headRadiusToMouseOffset
        
        let controlPointOffset = CGFloat(max(-1,min(1,Snowman.mood))) * mouthHeight
        
        let mouthRect = CGRect(x: headCenter.x - mouthWidth, y: headCenter.y + mouthOffset, width: 2 * mouthWidth, height: 2 * mouthHeight)
        
        let startPoint = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        
        let endPoint = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: startPoint.x + mouthRect.width / 3, y: startPoint.y + controlPointOffset)
        
        let cp2 = CGPoint(x: endPoint.x - mouthRect.width / 3, y: startPoint.y + controlPointOffset)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        return path
    }
    //-------------------------------------------------------
    
    // ARMS
    //-------------------------------------------------------
    enum Arms {
        case left, right
    }
    
    private func pathForArms (_ arm: Arms) -> UIBezierPath {
        
        var armOffset = secondCircleRadius / Constants.secondRadiusToArmOffset
        var startPointForArms = secondCircleCenter
        var armLenghth = secondCircleRadius / Constants.headRadiusToArmLenghth
        var fingerLenghth = armLenghth / Constants.armLenghthToFingerLenghth
        var armAngle = CGFloat()
        var endpointForArms = CGPoint()
        var firstFinger = CGPoint()
        var secondFinger = CGPoint()
        var thirdFinger = CGPoint()
        
        if arm == .left {
            armOffset = -armOffset
            armLenghth = -armLenghth
            fingerLenghth = -fingerLenghth
            armAngle = Snowman.leftArmAngle/4
        } else {
            armAngle = -Snowman.rightArmAngle/4
        }
        
        startPointForArms.x += armOffset
        startPointForArms.y -= sqrt(pow(secondCircleRadius, 2) - pow(armOffset, 2))
        endpointForArms = startPointForArms
        endpointForArms.x += armLenghth * cos(armAngle)
        endpointForArms.y += armLenghth * sin(armAngle)
        
        firstFinger = endpointForArms
        secondFinger = endpointForArms
        thirdFinger = endpointForArms
        firstFinger.x += fingerLenghth * cos(armAngle)
        firstFinger.y += fingerLenghth * sin(armAngle)
        secondFinger.x += fingerLenghth * cos(armAngle - fingerAngle/4)
        secondFinger.y += fingerLenghth * sin(armAngle - fingerAngle/4)
        thirdFinger.x += fingerLenghth * cos(armAngle + fingerAngle/4)
        thirdFinger.y += fingerLenghth * sin(armAngle + fingerAngle/4)
        
        let armsPath = UIBezierPath()
        armsPath.move(to: startPointForArms)
        armsPath.addLine(to: endpointForArms)
        armsPath.addLine(to: firstFinger)
        armsPath.move(to: endpointForArms)
        armsPath.addLine(to: secondFinger)
        armsPath.move(to: endpointForArms)
        armsPath.addLine(to: thirdFinger)
        
        armsPath.lineWidth = 3.0
        
        return armsPath
    }
    
    //-------------------------------------------------------
    
    // NOSE
    //-------------------------------------------------------
    private func pathForNouse () -> UIBezierPath {
        let noseOffset = headCircleRadius / Constants.headRadiusToNoseLenghth
        var noseFirstPoint = headCenter
        noseFirstPoint.y -= noseOffset/4
        var noseSecondPoint = headCenter
        noseSecondPoint.y += noseOffset/4
        var noseThirdPoint = headCenter
        noseThirdPoint.x -= noseOffset
        
        
        let nosePath = UIBezierPath()
        nosePath.move(to: noseFirstPoint)
        nosePath.addLine(to: noseThirdPoint)
        nosePath.addLine(to: noseSecondPoint)
        nosePath.addArc(withCenter: headCenter, radius: noseOffset / 4, startAngle: 1.5 * CGFloat.pi , endAngle: CGFloat.pi / 2, clockwise: true)
        
        return nosePath
    }
    //-------------------------------------------------------
    
    // LEGS
    //-------------------------------------------------------
    enum Legs {
        case left
        case right
    }
    
    private func pathForLegs(_ leg: Legs) -> UIBezierPath {
        
        let legOffset = secondCircleRadius / Constants.secondRadiusToLegOffset
        let legRadius = secondCircleRadius / Constants.secondRadiusToLegRadius
        var centerLeg = firstCircleCenter
        
        centerLeg.x += (leg == .left ? -1:1) * legOffset
        
        // first leg goes up, second goes down
        if leg == .right && Snowman.step != 0 {
            Snowman.step += 1
        }
        
        switch Snowman.step {
        case 0:
            centerLeg.y = firstCircleCenter.y + firstCircleRadius
        case let step where step % 2 == 0 :
            centerLeg.y = firstCircleCenter.y + firstCircleRadius
        case let step where abs(step) % 2 == 1:
            centerLeg.y = firstCircleCenter.y + firstCircleRadius - legRadius
        default:
            break
        }
        
        let legsPath = UIBezierPath(arcCenter: centerLeg, radius: legRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
        
        return legsPath
    }
    //-------------------------------------------------------
    
    // DRAW
    //-------------------------------------------------------
    
    override func draw(_ rect: CGRect) {
        
        UIColor.blue.set()
        pathForFirstCircle().fill()
        pathForSecondtCircle().fill()
        pathForHead().fill()
        
        UIColor.black.set()
        UIColor.white.setFill()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        
        pathForArms(.left).stroke()
        pathForArms(.right).stroke()
        
        UIColor.orange.setFill()
        pathForNouse().fill()
        
        pathForLegs(.left).fill()
        pathForLegs(.right).fill()
        
    }
    //-------------------------------------------------------
    
    
    
}
