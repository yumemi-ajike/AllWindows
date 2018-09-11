//
//  AppDelegate.swift
//  AllWindows
//
//  Created by 寺家 篤史 on 2018/08/17.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var previewWindow: NSWindow!
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var previewImageView: NSImageView!
    private var windows: [Window] = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        collectionView.register(NSNib(nibNamed: NSNib.Name(rawValue: "CollectionViewItem"), bundle: nil), forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"))
        let gridLayout = NSCollectionViewGridLayout()
        gridLayout.minimumItemSize = NSSize(width: 120, height: 90)
        gridLayout.maximumItemSize = NSSize(width: 240, height: 180)
        gridLayout.minimumInteritemSpacing = 10
        gridLayout.minimumLineSpacing = 10
        gridLayout.margins = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = gridLayout

        reloadWindows()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func reloadWindows() {
        windows.removeAll()
        if let windowInfos = CGWindowListCopyWindowInfo([.optionAll], 0) {
            for windowInfo in windowInfos as NSArray {
                if let info = windowInfo as? NSDictionary,
                    let window = Window(with: info) {
                    print("\(info)")
                    windows.append(window)
                }
            }
        }
        collectionView.reloadData()
    }

    @IBAction func updateButtonSelected(_ sender: Any) {
        reloadWindows()
    }
}

extension AppDelegate: NSCollectionViewDataSource, NSCollectionViewDelegate {
    // NSCollectionViewDataSource
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return windows.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as! CollectionViewItem
        let window = windows[indexPath.item]
        item.iconImageView?.image = window.image
        item.titleLabel?.stringValue = window.name ?? ""
        return item
    }

    // NSCollectionViewDelegate
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let item = indexPaths.first?.item {
            let window = windows[item]
            previewImageView.image = window.image
            previewWindow.title = window.name
            previewWindow.makeKeyAndOrderFront(nil)
        }
    }
}

