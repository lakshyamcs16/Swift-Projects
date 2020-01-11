//
//  ViewController.swift
//  Phone Tests
//
//  Created by Aashna Narula on 24/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var outputVolumeObserve: NSKeyValueObservation?
    let audioSession = AVAudioSession.sharedInstance()
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func listenVolumeButton() {
        do {
            try audioSession.setActive(true)
        } catch {}
        
        outputVolumeObserve = audioSession.observe(\.outputVolume) { (audioSession, changes) in
            /// TODOs
            print("hello")
        }
    }
    
    func getSignalStrength() -> Int {
        let application = UIApplication.shared
        let statusBarView = application.value(forKey: "statusBar") as! UIView
        let foregroundView = statusBarView.value(forKey: "foregroundView") as! UIView
        let foregroundViewSubviews = foregroundView.subviews
        
        var dataNetworkItemView:UIView!
        
        for subview in foregroundViewSubviews {
            if subview.isKind(of: NSClassFromString("UIStatusBarSignalStrengthItemView")!) {
                dataNetworkItemView = subview
                print("NONE")
                break
            } else {
                print("NO SERVICE")
                
                return 0 //NO SERVICE
            }
        }
        return dataNetworkItemView.value(forKey: "signalStrengthBars") as! Int
    }
    
    private func wifiStrength() -> Int? {
        let app = UIApplication.shared
        var rssi: Int?
        guard let statusBar = app.value(forKey: "statusBar") as? UIView, let foregroundView = statusBar.value(forKey: "foregroundView") as? UIView else {
            return rssi
        }
        for view in foregroundView.subviews {
            if let statusBarDataNetworkItemView = NSClassFromString("UIStatusBarDataNetworkItemView"), view .isKind(of: statusBarDataNetworkItemView) {
                if let val = view.value(forKey: "wifiStrengthRaw") as? Int {
                    //print("rssi: \(val)")
                    
                    rssi = val
                    break
                }
            }
        }
        return rssi
    }
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        switch batteryState {
        case .unplugged, .unknown:
            print("not charging")
        case .charging, .full:
            print("charging or full")
        }
    }
    
    func batteryChecker() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        
        print(UIDevice.current.batteryLevel)
        
        print(UIDevice.current.batteryState)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialize session an output variables this is necessary
        
        //Battery Checker helper code
//        self.batteryChecker()
//        print(self.getSignalStrength())
//        print(self.wifiStrength()!)
        print(UIDevice.modelName)
        print(UIDevice.current.getCPUName())
        print(UIDevice.current.getCPUSpeed())
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        var machineMirror = Mirror(reflecting: systemInfo.version)
        var identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print(identifier)
        
        machineMirror = Mirror(reflecting: systemInfo.sysname)
        identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print(identifier)
        
        machineMirror = Mirror(reflecting: systemInfo.nodename)
        identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print(identifier)
        
        machineMirror = Mirror(reflecting: systemInfo.release)
        identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print(identifier)
        
        machineMirror = Mirror(reflecting: systemInfo.machine)
        identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        print(identifier)
        
        print("Width: \(screenWidth) Height: \(screenHeight)")
        
        let nWidth = UIScreen.main.nativeBounds.width
        let nHeight = UIScreen.main.nativeBounds.height
        print("Native Width:\(nWidth) Native Height:\(nHeight)")
        
        switch (UIScreen.main.scale) {
            case 1.0: print("Non retina display")
            case 2.0: print("Retina display")
            case 3.0: print("Retina HD display")
            default: print("No info about retina display")
        }
        
        print(getPixelDensity(width: Double(nWidth), height: Double(nHeight)))

        print(ProcessInfo().operatingSystemVersion)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listenVolumeButton()
    }
    
}

public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

public extension UIDevice
{
    /**********************************************
     *  getCPUName():
     *     Returns a hardcoded value of the current
     * devices CPU name.
     ***********************************************/
    public func getCPUName() -> String
    {
        var processorNames = Array(CPUinfo().keys)
        return processorNames[0]
    }
    
    /**********************************************
     *  getCPUSpeed():
     *     Returns a hardcoded value of the current
     * devices CPU speed as specified by Apple.
     ***********************************************/
    public func getCPUSpeed() -> String
    {
        var processorSpeed = Array(CPUinfo().values)
        return processorSpeed[0]
    }
    
    /**********************************************
     *  CPUinfo:
     *     Returns a dictionary of the name of the
     *  current devices processor and speed.
     ***********************************************/
    private func CPUinfo() -> Dictionary<String, String> {
        
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif
        
        switch identifier {
        case "iPod5,1":                                 return ["A5":"800 MHz"] // underclocked
        case "iPod7,1":                                 return ["A8":"1.4 GHz"]
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return ["A4":"800 MHz"] // underclocked
        case "iPhone4,1":                               return ["A5":"800 MHz"] // underclocked
        case "iPhone5,1", "iPhone5,2":                  return ["A6":"1.3 GHz"]
        case "iPhone5,3", "iPhone5,4":                  return ["A6":"1.3 GHz"]
        case "iPhone6,1", "iPhone6,2":                  return ["A7":"1.3 GHz"]
        case "iPhone7,2":                               return ["A8":"1.4 GHz"]
        case "iPhone7,1":                               return ["A8":"1.4 GHz"]
        case "iPhone8,1":                               return ["A9":"1.85 GHz"]
        case "iPhone8,2":                               return ["A9":"1.85 GHz"]
        case "iPhone9,1", "iPhone9,3":                  return ["A10 Fusion":"2.34 GHz"]
        case "iPhone9,2", "iPhone9,4":                  return ["A10 Fusion":"2.34 GHz"]
        case "iPhone8,4":                               return ["A9":"1.85 GHz"]
        case "iPhone10,1", "iPhone10,4":                return ["A11 Bionic":"2.39 GHz"]
        case "iPhone10,2", "iPhone10,5":                return ["A11 Bionic":"2.39 GHz"]
        case "iPhone10,3", "iPhone10,6":                return ["A11 Bionic":"2.39 GHz"]
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return ["A5":"1.0 GHz"]
        case "iPad3,1", "iPad3,2", "iPad3,3":           return ["A5X":"1.0 GHz"]
        case "iPad3,4", "iPad3,5", "iPad3,6":           return ["A6X":"1.4 GHz"]
        case "iPad4,1", "iPad4,2", "iPad4,3":           return ["A7":"1.4 GHz"]
        case "iPad5,3", "iPad5,4":                      return ["A8X":"1.5 GHz"]
        case "iPad6,11", "iPad6,12":                    return ["A9":"1.85 GHz"]
        case "iPad2,5", "iPad2,6", "iPad2,7":           return ["A5":"1.0 GHz"]
        case "iPad4,4", "iPad4,5", "iPad4,6":           return ["A7":"1.3 GHz"]
        case "iPad4,7", "iPad4,8", "iPad4,9":           return ["A7":"1.3 GHz"]
        case "iPad5,1", "iPad5,2":                      return ["A8":"1.5 GHz"]
        case "iPad6,3", "iPad6,4":                      return ["A9X":"2.16 GHz"] // underclocked
        case "iPad6,7", "iPad6,8":                      return ["A9X":"2.24 GHz"]
        case "iPad7,1", "iPad7,2":                      return ["A10X Fusion":"2.34 GHz"]
        case "iPad7,3", "iPad7,4":                      return ["A10X Fusion":"2.34 GHz"]
        case "AppleTV5,3":                              return ["A8":"1.4 GHz"]
        case "AppleTV6,2":                              return ["A10X Fusion":"2.34 GHz"]
        case "AudioAccessory1,1":                       return ["A8":"1.4 GHz"] // clock speed is a guess
        default:                                        return ["N/A":"N/A"]
        }
    }
}

extension ViewController {
    func getPixelDensity( width w: Double, height h: Double) -> Double {
            let diagonal = sqrt(pow(w, 2) + pow(h, 2))
            let ppi = diagonal / 10
            return ppi
    }
}

