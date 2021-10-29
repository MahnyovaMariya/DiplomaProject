import Foundation
import UIKit

class Arrow {
    
    var arrowArray: [(Double, Double)]
    
    init(arrowArray: [(Double, Double)]) { self.arrowArray = arrowArray }
    
    func drawArrow(elem: Int) -> (UIView, CAShapeLayer, CAShapeLayer) {
        
        let arrowsView = UIView(frame: CGRect(x: arrowArray[elem].0, y: arrowArray[elem].1, width: 17, height: 13))
        arrowsView.backgroundColor = UIColor.white
        
        let bgForwardLine = UIBezierPath()
        let bgBackLine = UIBezierPath()
            
        bgForwardLine.move(to: CGPoint(x: 2, y: 13))
        bgForwardLine.addLine(to: CGPoint(x: 2, y: 3))
        bgForwardLine.addLine(to: CGPoint(x: 0, y: 3))
        bgForwardLine.addLine(to: CGPoint(x: 2, y: 0))
        bgForwardLine.addLine(to: CGPoint(x: 4, y: 3))
        bgForwardLine.addLine(to: CGPoint(x: 2, y: 3))
                
        bgBackLine.move(to: CGPoint(x: 15, y: 0))
        bgBackLine.addLine(to: CGPoint(x: 15, y: 10))
        bgBackLine.addLine(to: CGPoint(x: 17, y: 10))
        bgBackLine.addLine(to: CGPoint(x: 15, y: 13))
        bgBackLine.addLine(to: CGPoint(x: 13, y: 10))
        bgBackLine.addLine(to: CGPoint(x: 15, y: 10))
            
        bgForwardLine.close()
        bgBackLine.close()
            
        let bgForwardLineLayer = CAShapeLayer()
        let bgBackLineLayer = CAShapeLayer()
            
        bgForwardLineLayer.path = bgForwardLine.cgPath
        bgBackLineLayer.path = bgBackLine.cgPath
            
        bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
        bgBackLineLayer.strokeColor = CGColor(srgbRed: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
            
        bgForwardLineLayer.fillColor = nil
        bgBackLineLayer.fillColor = nil
            
        bgForwardLineLayer.lineWidth = 2.0
        bgBackLineLayer.lineWidth = 2.0
            
        arrowsView.layer.addSublayer(bgForwardLineLayer)
        arrowsView.layer.addSublayer(bgBackLineLayer)
            
        if arrowArray[elem].0 == 409 && arrowArray[elem].1 == 532 {
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
        } else if arrowArray[elem].0 == 568 && arrowArray[elem].1 == 532 {
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
        } else if arrowArray[elem].0 == 738 && arrowArray[elem].1 == 612 {
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
        } else if arrowArray[elem].0 == 557.5 && arrowArray[elem].1 == 635.5 {
            arrowsView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if arrowArray[elem].0 == 480.5 && arrowArray[elem].1 == 712.5 {
            arrowsView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if arrowArray[elem].0 == 397 && arrowArray[elem].1 == 794 {
            arrowsView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if arrowArray[elem].0 == 409 && arrowArray[elem].1 == 607 {
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
        } else if arrowArray[elem].0 == 426 && arrowArray[elem].1 == 623 {
            arrowsView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
        } else if arrowArray[elem].0 == 427 && arrowArray[elem].1 == 596 || arrowArray[elem].0 == 445 && arrowArray[elem].1 == 609 {
            arrowsView.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 3.5))
            bgForwardLineLayer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            bgBackLineLayer.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
        }
        
        return (arrowsView, bgForwardLineLayer, bgBackLineLayer)
    }
    
    static func workingArrows(checkPath: [Edge<String>], arrayForLayers: [(CAShapeLayer, CAShapeLayer)]) {
        
        let firstAnimation = CABasicAnimation(keyPath: "strokeEnd")
        firstAnimation.fromValue = 0
        firstAnimation.toValue = 1
        firstAnimation.duration = 2
        firstAnimation.repeatCount = .infinity
        
        let secondAnimation = CABasicAnimation(keyPath: "strokeEnd")
        secondAnimation.beginTime = CFTimeInterval(exactly: 1000.0)!
        secondAnimation.fromValue = 0
        secondAnimation.toValue = 1
        secondAnimation.duration = 2
        secondAnimation.repeatCount = .infinity
        
        for point in checkPath {
            if (point.source.index == 9 && point.destination.index == 45 || point.source.index == 45 && point.destination.index == 9){
                arrayForLayers[1].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[1].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 11 && point.destination.index == 54 || point.source.index == 54 && point.destination.index == 11) {
                arrayForLayers[3].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[3].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 12 && point.destination.index == 70 || point.source.index == 70 && point.destination.index == 12) {
                arrayForLayers[4].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[4].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 13 && point.destination.index == 31 || point.source.index == 31 && point.destination.index == 13) {
                arrayForLayers[5].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[5].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 29 && point.destination.index == 44 || point.source.index == 44 && point.destination.index == 29) {
                arrayForLayers[0].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[0].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 30 && point.destination.index == 69 ||
            point.source.index == 69 && point.destination.index == 30) {
                arrayForLayers[6].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[6].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 30 && point.destination.index == 53 ||
            point.source.index == 53 && point.destination.index == 30) {
                arrayForLayers[8].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[8].1.add(secondAnimation, forKey: "secondAnimation")
                arrayForLayers[9].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[9].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 69 && point.destination.index == 53 ||
            point.source.index == 53 && point.destination.index == 69) {
                arrayForLayers[7].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[7].1.add(secondAnimation, forKey: "secondAnimation")
            } else if (point.source.index == 47 && point.destination.index == 56 ||
            point.source.index == 56 && point.destination.index == 47) {
                arrayForLayers[2].0.add(firstAnimation, forKey: "firstAnimation")
                arrayForLayers[2].1.add(secondAnimation, forKey: "secondAnimation")
            }
        }
    }
}
