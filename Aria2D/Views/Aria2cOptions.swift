//
//  Aria2cOptions.swift
//  Aria2D
//
//  Created by xjbeta on 2019/1/11.
//  Copyright © 2019 xjbeta. All rights reserved.
//

import Foundation

@discardableResult // Add to suppress warnings when you don't want/need a result
func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    task.standardInput = nil

    try task.run() //<--updated

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}

struct Aria2cOptions {
    enum selectablePaths {
        case aria2c
        case aria2cConf
    }
    
    enum aria2cConfPaths: Int {
        case default🙂
        case custom
    }
    
    var customAria2c: String = {
        do {
            return try safeShell("which aria2c")
        } catch { }
        return ""
    }()

    let defaultAria2cConf: String = {
        do {
            var url = try FileManager.default.url(for: .applicationSupportDirectory , in: .userDomainMask, appropriateFor: nil, create: true)
            url.appendPathComponent(Bundle.main.bundleIdentifier!)
            url.appendPathComponent("Aria2D.conf")
            return url.path
        } catch { }
        return ""
    }()
    
    var customAria2cConf = ""
    var selectedAria2cConf: aria2cConfPaths = .default🙂
    var lastPID = ""
    var lastLaunch = ""
    
    init() {
    }
    
    mutating func resetLastConf() {
        lastPID = ""
        lastLaunch = ""
    }
    
    func path(for selectablePaths: selectablePaths) -> String {
        switch selectablePaths {
        case .aria2c:
            return customAria2c
        case .aria2cConf:
            switch selectedAria2cConf {
            case .default🙂:
                return defaultAria2cConf
            case .custom:
                return customAria2cConf == "" ? defaultAria2cConf : customAria2cConf
            }
        }
    }
    
    
    func selectedIndex(_ selectablePaths: selectablePaths) -> Int {
        switch selectablePaths {
        case .aria2c:
            return 0
        case .aria2cConf:
            switch selectedAria2cConf {
            case .default🙂:
                return 0
            case .custom:
                return customAria2cConf == "" ? 0 : 1
            }
        }
    }
    
    
    init?(data: Data) {
        if let coding = NSKeyedUnarchiver.unarchiveObject(with: data) as? Encoding {
            customAria2c = coding.customAria2c
            customAria2cConf = coding.customAria2cConf
            selectedAria2cConf = coding.selectedAria2cConf
            lastPID = coding.lastPID
            lastLaunch = coding.lastLaunchPath
        } else {
            return nil
        }
    }
    
    
    func encode() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: Encoding(self))
    }
    
    @objc(_TtCV6Aria2D13Aria2cOptionsP33_AF457B311616EC08278CC3017ADC7BED8Encoding)
    private class Encoding: NSObject, NSCoding {
        
        var customAria2c = ""
        var customAria2cConf = ""
        var selectedAria2cConf: aria2cConfPaths = .default🙂
        
        var lastPID = ""
        var lastLaunchPath = ""
        
        init(_ aria2cOptions: Aria2cOptions) {
            customAria2c = aria2cOptions.customAria2c
            customAria2cConf = aria2cOptions.customAria2cConf
            selectedAria2cConf = aria2cOptions.selectedAria2cConf
            lastPID = aria2cOptions.lastPID
            lastLaunchPath = aria2cOptions.lastLaunch
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.customAria2c = aDecoder.decodeObject(forKey: "customAria2c") as? String ?? ""
            self.customAria2cConf = aDecoder.decodeObject(forKey: "customAria2cConf") as? String ?? ""
            self.selectedAria2cConf = aria2cConfPaths(rawValue: aDecoder.decodeInteger(forKey: "selectedAria2cConf")) ?? .default🙂
            self.lastPID = aDecoder.decodeObject(forKey: "lastPID") as? String ?? ""
            self.lastLaunchPath = aDecoder.decodeObject(forKey: "lastLaunchPath") as? String ?? ""
        }
        
        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.customAria2c, forKey: "customAria2c")
            aCoder.encode(self.customAria2cConf, forKey: "customAria2cConf")
            aCoder.encode(self.selectedAria2cConf.rawValue, forKey: "selectedAria2cConf")
            aCoder.encode(self.lastPID, forKey: "lastPID")
            aCoder.encode(self.lastLaunchPath, forKey: "lastLaunchPath")
            
        }
    }
    
}
