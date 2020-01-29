//
//  StringConstants.swift
//  Toolchecker
//
//  Created by Aashna Narula on 25/01/20.
//  Copyright © 2020 Aashna Narula. All rights reserved.
//

import UIKit

class StringConstants {
    
    static let PROXIMITY: [String: Any] = [
        "name": "Proximity Sensor",
        "subtitle": """
                    Hold the device as you normally would while speaking
                    on the phone, or simply bring your hand over it.
                    \n
                    If result pop-up does not appear, tap the Check Sensor button.
                    """,
        "image": "proximity",
        "button": "Check Sensor"
    ]
    
    static let DISPLAY : [String: Any] = [
        "name" : "Display",
        "subtitle": """
                    The next screens will display a series of color
                    (green, red, and blue). Look carefully for dead or
                    stuck pixels or any discoloration.
                    \n
                    Tap the screen when you're ready for the next color.
                    """,
        "image": "display",
        "button": "Check Display"
    ]
    
    static let FLASH : [String: Any] = [
        "name" : "Flash",
        "subtitle": """
                    If flash light is working, it should turn on when Check Flash button is tapped.
                    """,
        "image": "flash",
        "button": "Check Flash"
    ]
    
    static let VIBRATE : [String: Any] = [
        "name" : "Vibrate",
        "subtitle": """
                    Device will vibrate one time when Check Vibration button is tapped.
                    """,
        "image": "vibrate",
        "button": "Check Vibration"
    ]
    
    static let SIMCARD : [String: Any] = [
        "name" : "SIM Card",
        "subtitle": """
                    Please insert a SIM Card and press the Check SIM Card button.
                    """,
        "image": "sim",
        "button": "Check SIM Card"
    ]
    
    static let WIFI : [String: Any] = [
        "name" : "Wifi",
        "subtitle": """
                    Wifi Connection is detected automatically.
                    \n
                    If result pop-up does not show up, please tap Check Wifi button.
                    """,
        "image": "wifi",
        "button": "Check Wifi"
    ]
    
    static let TOUCHSCREEN : [String: Any] = [
        "name": "Touch Screen",
        "subtitle": """
                    On the next screen, drag your finger over the screen until the whole
                    content turns red. \n
                    You have 20 seconds to complete the test
                    """,
        "image": "touch",
        "button": "Run Touch Test"
    ]
    
    static let FRONTCAMERA : [String: Any] = [
        "name":  "Front Camera",
        "subtitle":  "Tap to check whether Front Camera is working or not",
        "image":  "front",
        "button": "Check Front Camera"
    ]
    
    static let REARCAMERA : [String: Any] = [
        "name":  "Rear Camera",
        "subtitle":  "Tap to check whether Rear Camera is working or not",
        "image":  "rear",
        "button": "Check Rear Camera"
    ]
    
    static let SHAKE : [String: Any] = [
        "name":  "Shake Gesture",
        "subtitle":  "Tap to check whether Shake Gesture is working or not",
        "image":  "shake",
        "button": "Check Sensor"
    ]
    
    static let SPEAKER : [String: Any] = [
        "name":  "Speaker Test",
        "subtitle":  "Tap on Check Speakers button to hear the sound",
        "image":  "speaker",
        "button": "Check Speakers"
    ]
    
    static let HEADPHONES : [String: Any] = [
        "name":  "Headphone Jack test",
        "subtitle":  "Plugin the headphones and wait for the notification. If no notification is shown, headphone jack might be faulty",
        "image":  "headphone",
        "button": "Check Headphone"
    ]
    
    static let BUTTONS: [String: Any] = [
        "name":  "Buttons test",
        "subtitle":  "Press volume and power button one by one to complete the test",
        "image":  "button",
        "button": "Checkbox needs to be added"
    ]
    
    static let BATTERY: [String: Any] = [
        "name":  "Charging",
        "subtitle":  """
                     Please connect charging cable to device. Connection should be automatically detected.
                     \n
                     If result pop-up does not appear, tap the Check Connection button.
                     """,
        "image":  "battery",
        "button": "Check charging jack"
    ]
}
