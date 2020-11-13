//
//  ViewController.swift
//  StringEncrypt
//
//  Created by Hemanth on 11/11/20.
//  Copyright © 2020 Hemanth. All rights reserved.
//

import UIKit
import CommonCrypto

class ViewController: UIViewController {

    var str = "!@#$%^&*"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let encryptStr = str.sha256()
        print("Encrypt: \(encryptStr)")
        let shaData = sha256(string:str)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        print("shaHex: \(shaHex)")
    }
    
    func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_SHA256(messageBytes.baseAddress, CC_LONG(messageData.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        /*_ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }*/
        return digestData
    }

}

extension String {
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}

