//
//  Window.swift
//  AllWindows
//
//  Created by 寺家 篤史 on 2018/08/17.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import Cocoa

class Window {
    fileprivate(set) var id: CGWindowID = 0
    fileprivate(set) var name: String!
    fileprivate(set) var image: NSImage!
    
    init?(with windowInfo: NSDictionary) {
        let windowAlpha = windowInfo[Window.convert(CFString: kCGWindowAlpha)]
        let alpha = windowAlpha != nil ? (windowAlpha as! NSNumber).intValue : 0
        let windowBounds = windowInfo[Window.convert(CFString: kCGWindowBounds)]
        let bounds = windowBounds != nil ? CGRect(dictionaryRepresentation: windowBounds as! CFDictionary) ?? .zero : .zero
        let ownerName = windowInfo[Window.convert(CFString: kCGWindowOwnerName)]
        let name = ownerName != nil ? Window.convert(CFString: ownerName as! CFString) : ""
        let windowId = windowInfo[Window.convert(CFString: kCGWindowNumber)]
        let id = windowId != nil ? Window.convert(CFNumber: windowId as! CFNumber) : 0
        let image = NSImage.windowImage(with: id)

        guard
            alpha > 0,
            bounds.width > 100,
            bounds.height > 100,
            image.size.width > 1,
            image.size.height > 1,
            name != "Dock",
            name != "Window Server" else {
            return nil
        }

        self.id = id
        self.name = name
        self.image = image
    }
    
    fileprivate init() {}
}

private extension Window {
    class func convert(CFString cfString: CFString) -> String {
        return cfString as NSString as String
    }
    
    class func convert(CFNumber cfNumber: CFNumber) -> CGWindowID {
        return (cfNumber as NSNumber).uint32Value
    }
}

private extension NSImage {
    class func windowImage(with windowId: CGWindowID) -> NSImage {
        if let screenShot = CGWindowListCreateImage(CGRect.null, .optionIncludingWindow, CGWindowID(windowId), CGWindowImageOption()) {
            let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
            let image = NSImage()
            image.addRepresentation(bitmapRep)
            return image
        } else {
            return NSImage()
        }
    }
}
