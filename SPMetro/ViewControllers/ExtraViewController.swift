import UIKit

struct GetStationList {
    var indexStation: Int
    var nameStation: String
    var timeBetweenStations: Double
}

class ExtraViewController: UIViewController {
    
    var extraDetailPath: [GetStationList] = []

    override func viewDidLoad() { super.viewDidLoad() }
}

extension ExtraViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraDetailPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DetailPathTableViewCell
        cell.nameStationLabel.text = "\(extraDetailPath[indexPath.row].nameStation)"
        cell.timeLabel.text = "≈ \(lroundf(Float(extraDetailPath[indexPath.row].timeBetweenStations)))"
        
        if extraDetailPath[indexPath.row].timeBetweenStations == 1 || extraDetailPath[indexPath.row].timeBetweenStations == 1.9 || extraDetailPath[indexPath.row].timeBetweenStations == 2.9 {
            let head = createHead()
            let bodyLayer = createBody(addLineY: 31.5, lineWidth: 6.0)
            let rightHandLayer = createRightHand(moveX: 5.0, addLineX: 0.0, addLineY: 26.0, lineWidth: 3.0)
            let leftHandLayer = createLeftHand(moveX: 10.5, moveY: 16.0, addLineX: 13.5, addLineY: 22.5, lineWidth: 2.0)
            let rightLegLayer = createRightLeg(moveX: 3.0, moveY: 37.0, addLineX: 0.0, addLineY: 46.5, lineWidth: 3.0)
            let leftLegLayer = createLeftLeg(moveX: 6.5, moveY: 32.0, addLineX: 11.0, addLineY: 48.0, lineWidth: 3.5)
            
            cell.personView.layer.addSublayer(head)
            cell.personView.layer.addSublayer(bodyLayer)
            cell.personView.layer.addSublayer(rightHandLayer)
            cell.personView.layer.addSublayer(leftHandLayer)
            cell.personView.layer.addSublayer(rightLegLayer)
            cell.personView.layer.addSublayer(leftLegLayer)
                
            cell.infoLabel.text = """
                Переход на станцию "\(extraDetailPath[indexPath.row + 1].nameStation)" займет
                """
        } else {
            let head = createHead()
            let bodyLayer = createBody(addLineY: 29.5, lineWidth: 6.0)
            let rightHandLayer = createRightHand(moveX: 0.5, addLineX: 0.5, addLineY: 28.5, lineWidth: 2.5)
            let leftHandLayer = createLeftHand(moveX: 11.5, moveY: 13.5, addLineX: 11.5, addLineY: 28.5, lineWidth: 2.5)
            let rightLegLayer = createRightLeg(moveX: 3.5, moveY: 31.0, addLineX: 3.5, addLineY: 49.5, lineWidth: 3.5)
            let leftLegLayer = createLeftLeg(moveX: 8.5, moveY: 31.0, addLineX: 8.5, addLineY: 49.5, lineWidth: 3.5)
            
            cell.personView.layer.addSublayer(head)
            cell.personView.layer.addSublayer(bodyLayer)
            cell.personView.layer.addSublayer(rightHandLayer)
            cell.personView.layer.addSublayer(leftHandLayer)
            cell.personView.layer.addSublayer(rightLegLayer)
            cell.personView.layer.addSublayer(leftLegLayer)
            cell.infoLabel.text = "Проезд до следующей станции займет"
        }
        
        if cell.nameStationLabel.text == "Кировский завод" && cell.infoLabel.text == "Проезд до следующей станции займет" &&  extraDetailPath.last?.nameStation != cell.nameStationLabel.text && extraDetailPath[indexPath.row + 1].nameStation != "Автово" {
                cell.timeLabel.text = "≈ 4"
        } else if cell.nameStationLabel.text == "Василеостровская" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.last?.nameStation != cell.nameStationLabel.text && extraDetailPath[indexPath.row + 1].nameStation != "Гостиный двор" {
            cell.timeLabel.text = "≈ 4"
        } else if cell.nameStationLabel.text == "Владимирская" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.count - 1 != indexPath.row && extraDetailPath[indexPath.row + 1].nameStation != "Пушкинская" {
            cell.timeLabel.text = "≈ 2"
        } else if cell.nameStationLabel.text == "Площадь Александра Невского (з)" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.count - 1 != indexPath.row && extraDetailPath[indexPath.row + 1].nameStation != "Елизаровская" {
            cell.timeLabel.text = "≈ 3"
        } else if cell.nameStationLabel.text == "Новочеркасская" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.last?.nameStation != cell.nameStationLabel.text && extraDetailPath[indexPath.row + 1].nameStation != "Ладожская" {
            cell.timeLabel.text = "≈ 3"
        } else if cell.nameStationLabel.text == "Спортивная" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.last?.nameStation != cell.nameStationLabel.text && extraDetailPath[indexPath.row + 1].nameStation != "Адмиралтейская" {
            cell.timeLabel.text = "≈ 2"
        } else if cell.nameStationLabel.text == "Волковская" && cell.infoLabel.text == "Проезд до следующей станции займет" && extraDetailPath.last?.nameStation != cell.nameStationLabel.text && extraDetailPath[indexPath.row + 1].nameStation != "Бухарестская" {
            cell.timeLabel.text = "≈ 3"
        }
        
        if cell.nameStationLabel.text == "Новокрестовская" {
            cell.nameStationLabel.textColor = UIColor.gray
            cell.closeLabel.isHidden = false
            cell.closeLabel.textColor = UIColor.gray
            cell.closeLabel.text = "(закрыта)"
        }

        let (stationName, stationLayerPath) = createLine(elem: indexPath.row)
        cell.layer.addSublayer(stationName)
        cell.layer.addSublayer(stationLayerPath)
            
        if cell.nameStationLabel.text == extraDetailPath.last?.nameStation {
            cell.infoLabel.isHidden = true
            cell.minutesLabel.isHidden = true
            cell.timeLabel.isHidden = true
            stationLayerPath.strokeColor = CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.personView.layer.sublayers?.removeAll()
        }
        
        return cell
    }
    
    func createHead() -> CAShapeLayer {
        
        let head = CAShapeLayer()
        head.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 12, height: 12)).cgPath
        head.fillColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        return head
    }
    
    func createBody(addLineY: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        
        let body = UIBezierPath()
        body.move(to: CGPoint(x: 6, y: 3.5))
        body.addLine(to: CGPoint(x: 6, y: addLineY))
        
        var bodyLayer = CAShapeLayer()
        bodyLayer.path = body.cgPath
        bodyLayer = decorLayer(layer: bodyLayer, lineWidth: lineWidth)
        
        return bodyLayer
    }
    
    func createRightHand(moveX: CGFloat, addLineX: CGFloat, addLineY: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        
        let rightHand = UIBezierPath()
        rightHand.move(to: CGPoint(x: moveX, y: 13.5))
        rightHand.addLine(to: CGPoint(x: addLineX, y: addLineY))
        
        var rightHandLayer = CAShapeLayer()
        rightHandLayer.path = rightHand.cgPath
        rightHandLayer = decorLayer(layer: rightHandLayer, lineWidth: lineWidth)
        
        return rightHandLayer
    }
    
    func createLeftHand(moveX: CGFloat, moveY: CGFloat, addLineX: CGFloat, addLineY: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        
        let leftHand = UIBezierPath()
        leftHand.move(to: CGPoint(x: moveX, y: moveY))
        leftHand.addLine(to: CGPoint(x: addLineX, y: addLineY))
        
        var leftHandLayer = CAShapeLayer()
        leftHandLayer.path = leftHand.cgPath
        leftHandLayer = decorLayer(layer: leftHandLayer, lineWidth: lineWidth)
        
        return leftHandLayer
    }
    
    func createRightLeg(moveX: CGFloat, moveY: CGFloat, addLineX: CGFloat, addLineY: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        
        let rightLeg = UIBezierPath()
        rightLeg.move(to: CGPoint(x: moveX, y: moveY))
        rightLeg.addLine(to: CGPoint(x: addLineX, y: addLineY))
        
        var rightLegLayer = CAShapeLayer()
        rightLegLayer.path = rightLeg.cgPath
        rightLegLayer = decorLayer(layer: rightLegLayer, lineWidth: lineWidth)
        
        return rightLegLayer
    }
    
    func createLeftLeg(moveX: CGFloat, moveY: CGFloat, addLineX: CGFloat, addLineY: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let leftLeg = UIBezierPath()
        leftLeg.move(to: CGPoint(x: moveX, y: moveY))
        leftLeg.addLine(to: CGPoint(x: addLineX, y: addLineY))
        
        var leftLegLayer = CAShapeLayer()
        leftLegLayer.path = leftLeg.cgPath
        leftLegLayer = decorLayer(layer: leftLegLayer, lineWidth: lineWidth)
        
        return leftLegLayer
    }
    
    func decorLayer(layer: CAShapeLayer, lineWidth: CGFloat) -> CAShapeLayer {
        
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        return layer
    }
    
    func createLine(elem: Int) -> (CAShapeLayer, CAShapeLayer) {
        
        let stationName = CAShapeLayer()
        stationName.path = UIBezierPath(ovalIn: CGRect(x: 70, y: 5, width: 10, height: 10)).cgPath
        
        let stationPath = UIBezierPath()
        stationPath.move(to: CGPoint(x: 75, y: 20))
        stationPath.addLine(to: CGPoint(x: 75, y: 155))
        
        let stationLayerPath = CAShapeLayer()
        stationLayerPath.path = stationPath.cgPath
        
        if extraDetailPath[elem].indexStation >= 0 && extraDetailPath[elem].indexStation <= 20 {
            stationName.fillColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            stationLayerPath.strokeColor = CGColor(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        } else if extraDetailPath[elem].indexStation >= 21 && extraDetailPath[elem].indexStation <= 38 {
            stationName.fillColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
            stationLayerPath.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        } else if extraDetailPath[elem].indexStation >= 39 && extraDetailPath[elem].indexStation <= 52 {
            stationName.fillColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
            stationLayerPath.strokeColor = CGColor(srgbRed: 0.053, green: 0.723, blue: 0.224, alpha: 1.0)
        } else if extraDetailPath[elem].indexStation >= 53 && extraDetailPath[elem].indexStation <= 61 {
            stationName.fillColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
            stationLayerPath.strokeColor = CGColor(srgbRed: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
        } else if extraDetailPath[elem].indexStation >= 62 && extraDetailPath[elem].indexStation <= 78 {
            stationName.fillColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
            stationLayerPath.strokeColor = CGColor(srgbRed: 0.502, green: 0.0, blue: 0.502, alpha: 1.0)
        }
        
        stationLayerPath.fillColor = nil
        stationLayerPath.lineWidth = 6.0
        
        return (stationName, stationLayerPath)
    }
}
