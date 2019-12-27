//
//  AccessCameraVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 27/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit
import AVFoundation

class AccessCameraVC: UIViewController {
    
    class func newInstance() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AccessCameraVC") as? AccessCameraVC else {
            return UIViewController()
        }
        return vc
    }
    
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    @IBOutlet weak var cameraView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        session = AVCaptureSession()
        output = AVCaptureStillImageOutput()
        guard let camera = getDevice(position: .back) else {return}
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch let error as NSError {
            print(error)
            input = nil
        }
        if let input = input, let output = output, let session = session {
            if(session.canAddInput(input) == true){
                session.addInput(input)
                output.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
                if(session.canAddOutput(output) == true){
                    session.addOutput(output)
                    previewLayer = AVCaptureVideoPreviewLayer(session: session)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewLayer?.frame = cameraView.bounds
                    cameraView.layer.addSublayer(previewLayer!)
                    session.startRunning()
                }
            }
        }
    }
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position){
                return deviceConverted
            }
        }
        return nil
    }
}
