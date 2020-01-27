//
//  RealTimeDetectionViewController.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/21.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import UIKit
import Vision

class RealTimeDetectionViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    //MARK: value
    var videoCapture: VideoCapture!
    let visionRequestHandler = VNSequenceRequestHandler()
    
    //MARK: func
    func detextObject(image: CVImageBuffer) {
        do {
            let vnCoreMLModel = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: vnCoreMLModel, completionHandler: self.handleObjcetDetection)
            request.imageCropAndScaleOption = .centerCrop
            try self.visionRequestHandler.perform([request], on : image)
        }catch {
            print(error)
        }
    }
    
    func handleObjcetDetection(request: VNRequest, error: Error?) {
        if let result = request.results?.first as? VNClassificationObservation {
            DispatchQueue.main.async {
                self.categoryLabel.text = result.identifier
                self.confidenceLabel.text = "\(String(format: "%.1f", result.confidence * 100))%"
            }
        }
    }
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryLabel.text = ""
        self.confidenceLabel.text = ""

        let spec = VideoSpec(fps: 3, size: CGSize(width: 1280, height: 720))
        self.videoCapture = VideoCapture(cameraType: .back, preferredSpec: spec , previewContainer: self.cameraView.layer)
        
        self.videoCapture.imageBufferHandler = { (imageBuffer,timestamp,outputBuffer) in
            self.detextObject(image: imageBuffer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let videoCapture = self.videoCapture {
            videoCapture.startCapture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let videoCapture = self.videoCapture {
            videoCapture.stopCapture()
        }
    }

    

}
