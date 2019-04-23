//
//  String+Extensions.swift
//  Merchant
//
//  Copyright © 2019 Jean-Baptiste Dominguez
//  Copyright © 2019 Bitcoin.com
//

import BitcoinKit

extension String {
    func toCashAddress() throws -> String {
        return try AddressFactory.create(self).cashaddr
    }
    
    func toLegacy() throws -> String {
        return try AddressFactory.create(self).base58
    }
    
    func toSatoshis() -> Int {
        return Double(self)?.toSatoshis() ?? 0
    }
    
    func toDouble() -> Double {
        return Double(self.replacingOccurrences(of: ",", with: ".")) ?? 0
    }
    
    func toFormat(_ ticker: String, strict: Bool = true) -> String {
        var str = self
        var bothSide: [String.SubSequence]
        if str.contains(",") {
            bothSide = str.split(separator: ",")
        } else {
            bothSide = str.split(separator: ".")
        }
        let leftSide = String(bothSide[0])
        
        // Have right side with 2 numbers
        var rightSideStr = bothSide.count > 1 ? bothSide[1].description : ""
        if strict {
            while rightSideStr.count < 2 {
                rightSideStr.append("0")
            }
        }
        
        let characters:[Character] = leftSide.reversed()
        var fiatFormat:[Character] = characters.reversed()
        var numOfSpace = 0
        for (i, _) in characters.enumerated() {
            if i>0 && i%3 == 0 {
                fiatFormat.insert(" ", at: fiatFormat.count - i - numOfSpace)
                numOfSpace = numOfSpace + 1
            }
        }
        
        let leftSideStr = String(fiatFormat)
        
        switch ticker {
        case "USD":
//            if leftSideStr == "0" && rightSideStr == "00" {
//                str = "< $ 0,01"
//            } else {
                str = "$ \(leftSideStr)"
                if rightSideStr.count > 0 {
                    str = "\(str),\(rightSideStr)"
                }
//            }
            break
        case "EUR":
//            if leftSideStr == "0" && rightSideStr == "00" {
//                str = "< 0,01 €"
//            } else {
                str = "\(leftSideStr)"
                if rightSideStr.count > 0 {
                    str = "\(str),\(rightSideStr)"
                }
                str = "\(str) €"
//            }
            break
        default:
            str = "\(leftSideStr) \(ticker)"
            break
        }
        
        return str
    }
}
