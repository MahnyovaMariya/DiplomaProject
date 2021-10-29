import UIKit

struct GetData {
    var nameStation = ""
    var nameStationCoordinates = ""
    var stationCoordinates = ""
    var coordinatesForDrawLayer = ""
    var timeIntervalBetweenStations = 0
}

struct GetAdditionalInformation {
    var totalTime = 0.0
    var transferCount = 0
    var closeStation = 0
}

struct OutputData {
    var nameSection = ""
    var content: [GetAdditionalInformation] = []
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var metroMapUIView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    @IBAction func agreeClickButton(_ sender: Any) {
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -(self.infoView.frame.size.height + 50))
            self.extraView.layer.opacity = 0.0
        })
    }
    @IBOutlet weak var agreeButton: UIButton!
    @IBAction func cancelClickButton(_ sender: Any) {
        stationsNameArr = [""]
        countClick = 0
        extraButtonOne.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -(self.infoView.frame.size.height + 50))
            self.extraView.layer.opacity = 0.0
        })
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var extraView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var countClick = 0
    var tempL = 1
    
    let linesArray = ["RedLine", "BlueLine", "GreenLine",  "OrangeLine", "PurpleLine"]
    var stationsNameArr: [String] = [""]
    var stringCoordinatesForLayer: [String] = []
    var allPaths: [[Edge<String>]] = []
    var extraVariableForPath: [Edge<String>] = []
    var extraVariableForFirstPath: [Edge<String>] = []
    var extraVariableForSecondPath: [Edge<String>] = []
    var extraVariableForThirdPath: [Edge<String>] = []
    var vertexArr: [Vertex<String>] = []
    var dataArray: [GetData] = []
    var dataOutput: [OutputData] = []
    var arrayForLayers: [(CAShapeLayer, CAShapeLayer)] = []
    
    let line = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    var extraButtonOne = UIButton()
    var extraButtonTwo = UIButton()
    var graph = AdjacencyList<String>()
    var pathObject = Path(arrayOfTimeIntervals: [])
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popupWindowDecoration()
        scrollCustomization()
        tapGesture()
        
        let map = Map(countOfOrdinalElement: 0)
        
        for i in 0...linesArray.count - 1 {
            let (tempDataArray, linePath, stationPath, stationNameButton) = map.mapDecor(elem: linesArray[i], count: i)
            dataArray.append(contentsOf: tempDataArray)
            metroMapUIView.layer.addSublayer(linePath)
            
            for j in 0...stationPath.count - 1 { metroMapUIView.layer.addSublayer(stationPath[j]) }
            
            for x in 0...stationNameButton.count - 1 {
                let stationButton = stationNameButton[x]
                stationButton.addTarget(self, action: #selector(changeButtonStyle), for: UIControl.Event.touchDown)
                metroMapUIView.addSubview(stationButton)
            }
        }
        
        hidePartLine()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ExtraViewController, segue.identifier == "ShowDetailedPath" {
            vc.extraDetailPath.removeAll()
            tempL = 1
            
            for elem in extraVariableForPath {
                if elem.source.index != 10 && elem.source.index != 16 && elem.source.index != 42 && elem.source.index != 46 && elem.source.index != 57 && elem.source.index != 66 && elem.source.index != 72 {
                    vc.extraDetailPath.append(GetStationList(indexStation: elem.source.index, nameStation: elem.source.data, timeBetweenStations: elem.weight!))
                    if extraVariableForPath.count == tempL {
                        vc.extraDetailPath.append(GetStationList(indexStation: elem.destination.index, nameStation: elem.destination.data, timeBetweenStations: 0.0))
                    }
                } else if (elem.source.index == 10 || elem.source.index == 16 || elem.source.index == 42 || elem.source.index == 46 || elem.source.index == 57 || elem.source.index == 66 || elem.source.index == 72) && (extraVariableForPath.count == tempL) {
                    vc.extraDetailPath.append(GetStationList(indexStation: elem.destination.index, nameStation: elem.destination.data, timeBetweenStations: 0.0))
                }
                tempL += 1
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return metroMapUIView }
    
    func numberOfSections(in tableView: UITableView) -> Int { return dataOutput.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataOutput[section].content.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataOutput[section].nameSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! AddingInfoTableViewCell
        
        let calculatedTime = dataOutput[indexPath.section].content[indexPath.row].totalTime
        let calculatedTransfers = dataOutput[indexPath.section].content[indexPath.row].transferCount
        let calculatedCloseStation = dataOutput[indexPath.section].content[indexPath.row].closeStation
        
        cell.calculatedTimeLabel.text = "≈ \(String(lround(calculatedTime))) мин."
        cell.calculatedTransfersLabel.text = String(calculatedTransfers)
        cell.calculatedCloseStationLabel.text = String(calculatedCloseStation)
        cell.buildButton.tag = indexPath.section + indexPath.row

        cell.buildButton.addTarget(self, action: #selector(checkButton(button:)), for: UIControl.Event.touchDown)
        cell.buildButton.layer.cornerRadius = 28
        
        if cell.buildButton.tag == 0 {
            cell.buildButton.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.397, green: 0.682, blue: 0.431, alpha: 1.0))
            cell.buildButton.layer.shadowColor = CGColor(srgbRed: 0.332, green: 0.572, blue: 0.362, alpha: 1)
        } else if cell.buildButton.tag == 1 {
            if !extraVariableForSecondPath.isEmpty && !extraVariableForThirdPath.isEmpty {
                cell.buildButton.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.890, green: 0.877, blue: 0.148, alpha: 1.0))
                cell.buildButton.layer.shadowColor = CGColor(srgbRed: 0.814, green: 0.805, blue: 0.145, alpha: 1)
            } else if (!extraVariableForSecondPath.isEmpty && extraVariableForThirdPath.isEmpty) || (extraVariableForSecondPath.isEmpty) {
                cell.buildButton.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.933, green: 0.206, blue: 0.179, alpha: 1.0))
                cell.buildButton.layer.shadowColor = CGColor(srgbRed: 0.853, green: 0.191, blue: 0.167, alpha: 1)
            }
        } else if cell.buildButton.tag == 2 {
            cell.buildButton.backgroundColor = UIColor(cgColor: CGColor(srgbRed: 0.933, green: 0.206, blue: 0.179, alpha: 1.0))
            cell.buildButton.layer.shadowColor = CGColor(srgbRed: 0.853, green: 0.191, blue: 0.167, alpha: 1)
        }
        
        cell.buildButton.layer.shadowRadius = 1.5
        cell.buildButton.layer.shadowOpacity = 1.0
        
        return cell
    }
    
    @objc func checkButton(button: UIButton) {
        
        if button.tag == 0 {
            deleteLine()
            buildOneMorePath(oneMorePath: extraVariableForFirstPath, stringCoordinatesForLayer: stringCoordinatesForLayer, vertexArr: vertexArr)
            extraVariableForPath = extraVariableForFirstPath
        } else if button.tag == 1 {
            deleteLine()
            if !extraVariableForSecondPath.isEmpty {
                buildOneMorePath(oneMorePath: extraVariableForSecondPath, stringCoordinatesForLayer: stringCoordinatesForLayer, vertexArr: vertexArr)
                extraVariableForPath = extraVariableForSecondPath
            } else if extraVariableForSecondPath.isEmpty {
                buildOneMorePath(oneMorePath: extraVariableForThirdPath, stringCoordinatesForLayer: stringCoordinatesForLayer, vertexArr: vertexArr)
                extraVariableForPath = extraVariableForThirdPath
            }
        } else if button.tag == 2 {
            deleteLine()
            buildOneMorePath(oneMorePath: extraVariableForThirdPath, stringCoordinatesForLayer: stringCoordinatesForLayer, vertexArr: vertexArr)
            extraVariableForPath = extraVariableForThirdPath
        }
    }
    
    func popupWindowDecoration() {
        
        infoView.layer.borderColor = CGColor(srgbRed: 0.722, green: 0.722, blue: 0.722, alpha: 1.0)
        infoView.layer.borderWidth = 5.0
        infoView.layer.cornerRadius = 20.0
        
        agreeButton.layer.cornerRadius = 10.0
        cancelButton.layer.cornerRadius = 10.0
        
        agreeButton.layer.shadowRadius = 1.5
        cancelButton.layer.shadowRadius = 1.5
        
        agreeButton.layer.shadowOpacity = 1.0
        cancelButton.layer.shadowOpacity = 1.0
        
        agreeButton.layer.shadowColor = CGColor(srgbRed: 0.596, green: 0.737, blue: 0.896, alpha: 1.0)
        cancelButton.layer.shadowColor = CGColor(srgbRed: 0.596, green: 0.737, blue: 0.896, alpha: 1.0)
    }
    
    func scrollCustomization() {
        
        scroll.contentOffset = CGPoint(x: view.frame.size.width / 2 - view.frame.size.width / 3 - 50, y: 100)
        scroll.delegate = self
        scroll.minimumZoomScale = 0.6
        scroll.maximumZoomScale = 3.5
        scroll.zoomScale = 0.85
    }

    func tapGesture() {
        
        let tapSelectLineGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.metroMapUIView.addGestureRecognizer(tapSelectLineGesture)
        self.metroMapUIView.isUserInteractionEnabled = true
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: metroMapUIView)
        let shapeLayer1 = line.cgPath.copy(strokingWithWidth: 6.0, lineCap: .butt, lineJoin: .round, miterLimit: 0)
        
        if shapeLayer1.contains(point, using: .winding, transform: .identity) == true {
            performSegue(withIdentifier: "ShowDetailedPath", sender: nil)
        } else { dataReset() }
    }

    func dataReset() {
        
        if allPaths.count == 3 {
            heightConstraint.constant += 0
        } else if allPaths.count == 2 {
            heightConstraint.constant += 60
        } else if allPaths.count == 1 {
            heightConstraint.constant += 148
        }
        
        tableView.reloadData()
        deleteLine()
        tableView.layoutIfNeeded()
        PathsList.hideAdditionalInformation(table: tableView, scroll: scroll)
        stationsNameArr = [""]
        allPaths.removeAll()
        extraVariableForFirstPath.removeAll()
        extraVariableForSecondPath.removeAll()
        extraVariableForThirdPath.removeAll()
        stringCoordinatesForLayer.removeAll()
        dataOutput.removeAll()
        vertexArr.removeAll()
        graph = AdjacencyList<String>()
        pathObject = Path(arrayOfTimeIntervals: [])
        countClick = 0
        tempL = 1
        extraButtonOne.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        extraButtonTwo.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    func deleteLine() {
        
        line.removeAllPoints()
        shapeLayer.strokeColor = nil
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 0.0
        extraVariableForPath.removeAll()
        updateLayers(layersArr: arrayForLayers)
    }
    
    func updateLayers(layersArr: [(CAShapeLayer, CAShapeLayer)]) {
        
        for i in 0...layersArr.count - 1 {
            layersArr[i].0.removeAllAnimations()
            layersArr[i].1.removeAllAnimations()
        }
    }
    
    func hidePartLine() {
        
        let arrowPoints: [(Double, Double)] = [(409, 532),(568, 532),(738, 612), (557.5, 635.5), (480.5, 712.5), (397, 794), (409, 607), (426, 623), (427, 596), (445, 609)]
        
        let firstHidePartLineView = UIView(frame: CGRect(x: 415, y: 596, width: 4, height: 29.5))
        firstHidePartLineView.backgroundColor = UIColor.white
        let secondHidePartLineView = UIView(frame: CGRect(x: 409.5, y: 794, width: 5, height: 5))
        secondHidePartLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        secondHidePartLineView.backgroundColor = UIColor.white
        let thirdHidePartLineView = UIView(frame: CGRect(x: 569.5, y: 634, width: 7, height: 7))
        thirdHidePartLineView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 6.5)
        thirdHidePartLineView.backgroundColor = UIColor.white
        
        metroMapUIView.addSubview(firstHidePartLineView)
        metroMapUIView.addSubview(secondHidePartLineView)
        metroMapUIView.addSubview(thirdHidePartLineView)
        
        let arrows = Arrow(arrowArray: arrowPoints)
        
        for i in 0...arrowPoints.count - 1 {
            let (view, layerOne, layerTwo) = arrows.drawArrow(elem: i)
            metroMapUIView.addSubview(view)
            arrayForLayers.append((layerOne, layerTwo))
        }
    }

    func buildOneMorePath(oneMorePath: [Edge<String>], stringCoordinatesForLayer: [String], vertexArr: [Vertex<String>]) {
        
        var tempArrayOfPoints: [CGPoint] = []
        let pointCoordinatesForLayer = stringCoordinatesForLayer.map { NSCoder.cgPoint(for: $0)}
        var indexNumber = 0
        var incr = 0
        
        for edge in oneMorePath {
            for i in 0...vertexArr.count - 1 {
                if indexNumber <= oneMorePath.count {
                    if edge.source.data == vertexArr[i].data  {
                        for j in 0...pointCoordinatesForLayer.count - 1 {
                            if i == j { tempArrayOfPoints.append(pointCoordinatesForLayer[j]) }
                        }
                        indexNumber += 1
                        if indexNumber == oneMorePath.count { incr += 1 }
                    }
                }
            }
            if incr == 1 {
                for i in 0...vertexArr.count - 1 {
                    if edge.destination.data == vertexArr[i].data  {
                        for j in 0...pointCoordinatesForLayer.count - 1 {
                            if i == j {
                                tempArrayOfPoints.append(pointCoordinatesForLayer[j])
                            }
                        }
                    }
                }
            }
        }
        
        scroll.zoomScale = 0.85
        
        let startPoint: CGPoint = CGPoint(x: tempArrayOfPoints[0].x, y: tempArrayOfPoints[0].y)
        line.move(to: startPoint)
        
        for i in 1...tempArrayOfPoints.count - 1 {
            line.addLine(to: CGPoint(x: tempArrayOfPoints[i].x, y: tempArrayOfPoints[i].y))
        }
        
        shapeLayer.path = line.cgPath
        shapeLayer.strokeColor = CGColor(srgbRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 7.0
        shapeLayer.lineDashPattern = [1, 1]
        metroMapUIView.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        
        shapeLayer.add(animation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Arrow.workingArrows(checkPath: oneMorePath, arrayForLayers: self.arrayForLayers)
        }
    }
    
    @objc func changeButtonStyle(button: UIButton) {
        
        if countClick == 0 {
            buttonDecoration(firstButton: button)
        } else if countClick == 1 {
            extraButtonTwo = button
            if extraButtonTwo.titleLabel?.text != extraButtonOne.titleLabel?.text {
                extraButtonTwo.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
                extraButtonTwo.frame.size.width = (extraButtonTwo.titleLabel?.frame.width)! as CGFloat + 15
                getStation(stationName: (extraButtonTwo.titleLabel?.text)!, countClick: countClick)
                countClick += 1
            } else if extraButtonTwo.titleLabel?.text == extraButtonOne.titleLabel?.text {
                UIView.animate(withDuration: 1.0, animations: { () -> Void in
                    self.extraView.layer.opacity = 0.45
                    self.infoView.transform = CGAffineTransform(translationX: 0, y: self.infoView.frame.size.height + 50)
                })
            }
        } else if countClick > 1 {
            dataReset()
            buttonDecoration(firstButton: button)
        }
        
        if stationsNameArr.count == 3 {
            stringCoordinatesForLayer = pathObject.createVertexes(dataArray: dataArray)
            (graph, vertexArr) = pathObject.createEdges()
            var firstNumb = 0
            var lastNumb = 0
            
            for i in 0...stationsNameArr.count - 1 {
                for j in 0...vertexArr.count - 1 {
                    if (stationsNameArr[i] == vertexArr[j].data) && (i == 0) {
                        firstNumb = j
                    } else if (stationsNameArr[i] == vertexArr[j].data) && (i == 1) {
                        lastNumb = j
                    }
                }
            }
            
            let dijkstra = Dijkstra(graph: graph)
            let path = pathObject.buildFirstPath(newDijkstra: dijkstra, firstElem: firstNumb, lastElem: lastNumb)
            let secondPath = pathObject.buildSecondPath(newDijkstra: dijkstra, firstElem: firstNumb, lastElem: lastNumb)
            let thirdPath = pathObject.buildThirdPath(newDijkstra: dijkstra, firstElem: firstNumb, lastElem: lastNumb)
            (allPaths, extraVariableForFirstPath, extraVariableForSecondPath, extraVariableForThirdPath) = pathObject.searchIdenticalPaths(firstPath: path, secondPath: secondPath, thirdPath: thirdPath)
            let firstPathTime = PathsList.getAdditionalInformation(anyPath: allPaths)
            dataOutput = PathsList.makeSections(arrayOfData: firstPathTime)
            
            if firstPathTime.count == 3 {
                heightConstraint.constant += 0
            } else if firstPathTime.count == 2 {
                heightConstraint.constant -= 60
            } else if firstPathTime.count == 1 {
                heightConstraint.constant -= 148
            }
            
            tableView.layoutIfNeeded()
            tableView.reloadData()
            
            PathsList.showAdditionalInformation(table: tableView, scroll: scroll)
            buildOneMorePath(oneMorePath: path, stringCoordinatesForLayer: stringCoordinatesForLayer, vertexArr: vertexArr)
            extraVariableForPath = path
        }
    }
    
    func buttonDecoration(firstButton: UIButton) {
        
        extraButtonOne = firstButton
        extraButtonOne.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        extraButtonOne.frame.size.width = (extraButtonOne.titleLabel?.frame.width)! as CGFloat + 15
        getStation(stationName: (extraButtonOne.titleLabel?.text)!, countClick: countClick)
        countClick += 1
    }
    
    func getStation(stationName: String, countClick: Int) { stationsNameArr.insert(stationName, at: countClick) }
}
