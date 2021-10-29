import Foundation
import UIKit

class Map {

    var countOfOrdinalElement: Int
    
    init(countOfOrdinalElement: Int) {
        self.countOfOrdinalElement = countOfOrdinalElement
    }
    
    func mapDecor(elem: String, count: Int) -> ([GetData], CAShapeLayer, [CAShapeLayer], [UIButton]) {
        
        var stringCoordinatesForLine: [String] = []
        var stringCoordinatesForPoint: [String] = []
        var stringCoordinatesForNames: [String] = []
        var arrayOfNames: [String] = []
        var tempDataArray: [GetData] = Array(repeating: GetData(nameStation: "", nameStationCoordinates: "", stationCoordinates: "", coordinatesForDrawLayer: "", timeIntervalBetweenStations: 0), count: 21)
        
        guard let points = plist(plist: elem) else { fatalError() }
            
        for j in 0...points.count - 1 {
            for k in 0...points[j].count - 1 {
                if j == 0 {
                    tempDataArray[k].nameStation = points[j][k]
                } else if j == 1 {
                    tempDataArray[k].nameStationCoordinates = points[j][k]
                } else if j == 2 {
                    tempDataArray[k].stationCoordinates = points[j][k]
                } else if j == 3 {
                    tempDataArray[k].coordinatesForDrawLayer = points[j][k]
                } else if j == 4 {
                    tempDataArray[k].timeIntervalBetweenStations = Int(points[j][k])!
                }
            }
        }
        
        for element in 0...tempDataArray.count - 1 {
            if tempDataArray[element].coordinatesForDrawLayer != "" {
                stringCoordinatesForLine.append(tempDataArray[element].coordinatesForDrawLayer)
                stringCoordinatesForPoint.append(tempDataArray[element].stationCoordinates)
                stringCoordinatesForNames.append(tempDataArray[element].nameStationCoordinates)
                arrayOfNames.append(tempDataArray[element].nameStation)
            }
        }
        
        let pointCoordinatesForPoint = stringCoordinatesForPoint.map {NSCoder.cgPoint(for: $0)}
        let pointCoordinatesForLine = stringCoordinatesForLine.map {NSCoder.cgPoint(for: $0)}
        let pointCoordinatesForNames = stringCoordinatesForNames.map {NSCoder.cgPoint(for: $0)}
        
        var linePath = CAShapeLayer()
        var stationPath = [CAShapeLayer()]
        var stationNameButton = [UIButton()]
        
        switch count {
            case 0:
                linePath = drawLine(coordArray: pointCoordinatesForLine, colorLine: "red")
                stationPath = pointCoordinatesForPoint.map {drawStation(coordX: $0.x, coordY: $0.y, stationColor: "red")}
            case 1:
                linePath = drawLine(coordArray: pointCoordinatesForLine, colorLine: "blue")
                stationPath = pointCoordinatesForPoint.map {drawStation(coordX: $0.x, coordY: $0.y, stationColor: "blue")}
            case 2:
                linePath = drawLine(coordArray: pointCoordinatesForLine, colorLine: "green")
                stationPath = pointCoordinatesForPoint.map {drawStation(coordX: $0.x, coordY: $0.y, stationColor: "green")}
            case 3:
                linePath  = drawLine(coordArray: pointCoordinatesForLine, colorLine: "orange")
                stationPath = pointCoordinatesForPoint.map {drawStation(coordX: $0.x, coordY: $0.y, stationColor: "orange")}
            case 4:
                linePath = drawLine(coordArray: pointCoordinatesForLine, colorLine: "purple")
                stationPath = pointCoordinatesForPoint.map {drawStation(coordX: $0.x, coordY: $0.y, stationColor: "purple")}
            default:
                print("!")
        }
        
        stationNameButton = pointCoordinatesForNames.map { writeNameStation(coordX: $0.x, coordY: $0.y, stationName: arrayOfNames)}
        
        stringCoordinatesForLine.removeAll()
        stringCoordinatesForPoint.removeAll()
        stringCoordinatesForNames.removeAll()
        arrayOfNames.removeAll()
        
        return (tempDataArray, linePath, stationPath, stationNameButton)
    }
    
    func plist(plist: String) -> [[String]]? {
        
        guard let filePath = Bundle.main.path(forResource: plist, ofType: "plist"), let data = FileManager.default.contents(atPath: filePath) else { return nil}
        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String]]
        }
        catch { return nil }
    }
    
    func drawLine(coordArray: [CGPoint], colorLine: String) -> CAShapeLayer {
        
        let startPoint: CGPoint = CGPoint(x: coordArray[0].x, y: coordArray[0].y)
        let line = UIBezierPath()
        line.move(to: startPoint)
        
        for i in 1...coordArray.count-1 {
            line.addLine(to: CGPoint(x: coordArray[i].x, y: coordArray[i].y))
        }
        
        let linePath = CAShapeLayer()
        linePath.path = line.cgPath
        
        switch colorLine {
            case "red":
                linePath.strokeColor = UIColor.red.cgColor
            case "blue":
                linePath.strokeColor = UIColor.blue.cgColor
            case "green":
                linePath.strokeColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
            case "orange":
                linePath.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
            case "purple":
                linePath.strokeColor = UIColor.purple.cgColor
            default:
                linePath.strokeColor = UIColor.yellow.cgColor
        }
        
        linePath.fillColor = nil
        linePath.lineWidth = 0.5
        
        return linePath
    }
    
    func drawStation(coordX: CGFloat, coordY: CGFloat, stationColor: String) -> CAShapeLayer {
        
        let stationPath = CAShapeLayer()
        stationPath.path = UIBezierPath(ovalIn: CGRect(x: coordX, y: coordY, width: 10, height: 10)).cgPath
        
        switch stationColor {
            case "red":
                if coordY != 990.0 && coordY != 634.0 {
                    stationPath.fillColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                } else {
                    stationPath.fillColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
                }
            case "blue":
                stationPath.fillColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            case "green":
                if coordY != 549.0 && coordY != 450.0  {
                    stationPath.fillColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
                } else if coordY == 450.0 {
                    stationPath.fillColor = CGColor(srgbRed: 0.456, green: 0.456, blue: 0.456, alpha: 1.0)
                } else if coordY == 549.0 {
                    stationPath.fillColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 0.0)
                }
            case "orange":
                if coordY != 624.0 {
                    stationPath.fillColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
                } else {
                    stationPath.fillColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 0.0)
                }
            case "purple":
                if coordY != 509.0 && coordY != 789.0 {
                    stationPath.fillColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
                } else {
                    stationPath.fillColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 0.0)
                }
            default:
                print("!")
        }
        
        stationPath.lineWidth = 3.0
        
        return stationPath
    }
    
    func writeNameStation(coordX: CGFloat, coordY: CGFloat, stationName: [String]) -> UIButton {
        
        let stationNameButton = UIButton(frame: CGRect(x: coordX, y: coordY, width: 310, height: 15))
        stationNameButton.setTitle(stationName[countOfOrdinalElement], for: .normal)
        
        if coordX != 105 && coordY != 440 {
            stationNameButton.setTitleColor(.black, for: .normal)
        } else {
            stationNameButton.setTitleColor(.gray, for: .normal)
        }
        
        stationNameButton.contentHorizontalAlignment = .left
        stationNameButton.frame.size.width = (stationNameButton.titleLabel?.frame.width)! as CGFloat
        countOfOrdinalElement += 1
        
        if countOfOrdinalElement == stationName.count { countOfOrdinalElement = 0 }
        
        return stationNameButton
    }
}
