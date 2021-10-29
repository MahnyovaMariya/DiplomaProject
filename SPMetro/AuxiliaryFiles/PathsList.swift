import Foundation
import UIKit

class PathsList {
    
    static func getAdditionalInformation(anyPath: [[Edge<String>]]) -> [GetAdditionalInformation] {
        
        var arrayOfAdditionalInformation: [GetAdditionalInformation] = []
        var totalTime = 0.0
        var transferCount = 0
        var closeStation = 0
        var tempCount = 0
        
        for i in 0...anyPath.count - 1 {
            for subPath in anyPath[i] {
                tempCount += 1
                totalTime += subPath.weight!
                
                if (subPath.source.index == 9 && subPath.destination.index == 45 || subPath.source.index == 45 && subPath.destination.index == 9) || (subPath.source.index == 11 && subPath.destination.index == 54 || subPath.source.index == 54 && subPath.destination.index == 11) || (subPath.source.index == 12 && subPath.destination.index == 70 || subPath.source.index == 70 && subPath.destination.index == 12) || (subPath.source.index == 13 && subPath.destination.index == 31 || subPath.source.index == 31 && subPath.destination.index == 13) || (subPath.source.index == 29 && subPath.destination.index == 44 || subPath.source.index == 44 && subPath.destination.index == 29) || (subPath.source.index == 30 && subPath.destination.index == 69 || subPath.source.index == 69 && subPath.destination.index == 30) || (subPath.source.index == 30 && subPath.destination.index == 53 || subPath.source.index == 53 && subPath.destination.index == 30) || (subPath.source.index == 69 && subPath.destination.index == 53 || subPath.source.index == 53 && subPath.destination.index == 69) || (subPath.source.index == 47 && subPath.destination.index == 56 || subPath.source.index == 56 && subPath.destination.index == 47) {
                    transferCount += 1
                }
                
                if subPath.source.index == 40 || (subPath.destination.index == 40 && anyPath[i].count == tempCount) {
                    closeStation += 1
                }
            }
            
            arrayOfAdditionalInformation.append(GetAdditionalInformation(totalTime: totalTime, transferCount: transferCount, closeStation: closeStation))
            
            totalTime = 0.0
            transferCount = 0
            closeStation = 0
            tempCount = 0
        }
        
        return arrayOfAdditionalInformation
    }
    
    static func showAdditionalInformation(table: UITableView, scroll: UIScrollView) {
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            table.isHidden = false
            table.transform = CGAffineTransform(translationX: 0, y: table.frame.size.height)
            scroll.transform = CGAffineTransform(translationX: 0, y: table.frame.size.height - 110)
        })
    }

    static func hideAdditionalInformation(table: UITableView, scroll: UIScrollView) {
        
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            table.isHidden = true
            table.transform = CGAffineTransform(translationX: 0, y: -(table.frame.size.height))
            scroll.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    static func makeSections(arrayOfData: [GetAdditionalInformation]) -> [OutputData] {
        
        var a: [OutputData] = []
        
        if arrayOfData.count == 1 {
            a = [OutputData(nameSection: "Самый короткий путь", content: [GetAdditionalInformation(totalTime: arrayOfData[0].totalTime, transferCount: arrayOfData[0].transferCount, closeStation: arrayOfData[0].closeStation)])]
        } else if arrayOfData.count  == 2 {
            a = [OutputData(nameSection: "Самый короткий путь", content: [GetAdditionalInformation(totalTime: arrayOfData[0].totalTime, transferCount: arrayOfData[0].transferCount, closeStation: arrayOfData[0].closeStation)]),
                OutputData(nameSection: "Альтернативный маршрут", content: [GetAdditionalInformation(totalTime: arrayOfData[1].totalTime, transferCount: arrayOfData[1].transferCount, closeStation: arrayOfData[1].closeStation)])]
        } else if arrayOfData.count == 3 {
            a = [
                OutputData(nameSection: "Самый короткий путь", content: [GetAdditionalInformation(totalTime: arrayOfData[0].totalTime, transferCount: arrayOfData[0].transferCount, closeStation: arrayOfData[0].closeStation)]),
                OutputData(nameSection: "Альтернативные маршруты", content: [GetAdditionalInformation(totalTime: arrayOfData[1].totalTime, transferCount: arrayOfData[1].transferCount, closeStation: arrayOfData[1].closeStation), GetAdditionalInformation(totalTime: arrayOfData[2].totalTime, transferCount: arrayOfData[2].transferCount, closeStation: arrayOfData[2].closeStation)])
            ]
        }
        
        return a
    }
}
