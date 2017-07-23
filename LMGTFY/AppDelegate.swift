//
//  AppDelegate.swift
//  LMGTFY
//
//  Created by Steve Kerney on 7/22/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    //MARK: Data
    var item: NSStatusItem? = nil;
    fileprivate var selectedSearchEngine: SearchEngineType = .Google;

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        item = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength);
        
        let appIconImage = NSImage(named: "menuBarIcon");
        appIconImage?.size = NSSize(width: 18, height: 18);
        item?.image = appIconImage;
        
        let menu = NSMenu();
        menu.addItem(NSMenuItem(title: "Generate Link", action: #selector(AppDelegate.generateLMGTFYLink), keyEquivalent: ""));
        
        let searchEngineSelectionMenuItem = NSMenuItem(title: "Search Engine", action: nil, keyEquivalent: "");
        let searchEngineSelectionMenu = NSMenu();
        searchEngineSelectionMenu.addItem(withTitle: "Google", action: #selector(AppDelegate.setSearchPrefGoogle), keyEquivalent: "");
        searchEngineSelectionMenu.addItem(withTitle: "Bing", action: #selector(AppDelegate.setSearchPrefBing), keyEquivalent: "");
        searchEngineSelectionMenu.addItem(withTitle: "Yahoo", action: #selector(AppDelegate.setSearchPrefYahoo), keyEquivalent: "");
        searchEngineSelectionMenu.addItem(withTitle: "DuckDuckGo", action: #selector(AppDelegate.setSearchPrefDuckDuckGo), keyEquivalent: "");
        searchEngineSelectionMenuItem.submenu = searchEngineSelectionMenu;
        menu.addItem(searchEngineSelectionMenuItem);
        
        menu.addItem(NSMenuItem.separator());
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: ""));

        item?.menu = menu;
    }

    //MARK: Main Functions
    func generateLMGTFYLink()
    {
        guard let pasteBoardItems = NSPasteboard.general().pasteboardItems else { return; }
        
        for aPasteItem in pasteBoardItems
        {
            for aPasteType in aPasteItem.types
            {
                if (aPasteType == rawTextType)
                {
                    guard let pasteItemText = aPasteItem.string(forType: aPasteType) else { return; }
                    
                    NSPasteboard.general().clearContents();
                    let fullURL = selectedSearchEngine.rawValue.appending(pasteItemText);
                    NSPasteboard.general().setString(fullURL, forType: rawTextType);
                }
            }
        }
    }
    
    func quit() { NSApplication.shared().terminate(self); }

    func applicationWillTerminate(_ aNotification: Notification) { }
    
    //MARK: Helper Functions
    func setSearchPrefGoogle() { selectedSearchEngine = .Google; }
    func setSearchPrefBing() { selectedSearchEngine = .Bing; }
    func setSearchPrefYahoo() { selectedSearchEngine = .Yahoo; }
    func setSearchPrefDuckDuckGo() { selectedSearchEngine = .DuckDuckGo; }
}
