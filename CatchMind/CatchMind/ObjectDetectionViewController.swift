//
//  ObjectDetectionViewController.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/21.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import UIKit
import Vision

class ObjectDetectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: value
    var selectedImage: UIImage? {
        didSet {
            self.selectImageView.image = selectedImage
        }
    }
    
    var selectedciImage: CIImage? {
        get {
            if let selectedImage = self.selectedImage {
                return CIImage(image: selectedImage)
            }else {
                return nil
            }
        }
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    
    
    //MARK: IBAction
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        //
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let importFromAlbum = UIAlertAction(title: "앨범에서 가져오기", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        }
        let takePhoto = UIAlertAction(title: "카메라로 찍기", style: .default) { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        }
        let cacel = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        
        actionSheet.addAction(importFromAlbum)
        actionSheet.addAction(takePhoto)
        actionSheet.addAction(cacel)
        
        self.present(actionSheet,animated: true, completion: nil)
    }
    
    //MARK: func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            picker.dismiss(animated: true)
            self.selectedImage = editedImage
            DispatchQueue.global(qos: .userInitiated).async {
                self.detectObjcet()
            }
        }
    }
    
    func detectObjcet() {
        if let ciImage = self.selectedciImage {
            do {
                let vnCoreMLModel = try VNCoreMLModel(for: Inceptionv3().model)
                
                let request = VNCoreMLRequest(model: vnCoreMLModel, completionHandler: self.handleObjectDetection)
                request.imageCropAndScaleOption = .centerCrop
                
                let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
                try requestHandler.perform([request])
            }catch {
                print(error)
            }
        }
    }
    
    func handleObjectDetection(request: VNRequest, error: Error?) {
        if let result = request.results?.first as? VNClassificationObservation {
            self.categoryLabel.text = result.identifier
            self.confidenceLabel.text = "\(String(format: "%.1f", result.confidence*100))%"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.categoryLabel.text = ""
        self.confidenceLabel.text = ""
    }
    
    

}
