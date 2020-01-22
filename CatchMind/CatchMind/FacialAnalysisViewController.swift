//
//  FacialAnalysisViewController.swift
//  CatchMind
//
//  Created by kwangrae kim on 2020/01/21.
//  Copyright © 2020 conyconydev. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class FacialAnalysisViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: value
    
    var selectedImage: UIImage? {
        didSet {
            self.blurredImageView.image = selectedImage
            self.selectedImageView.image = selectedImage
        }
    }
    
    var selectedCiImage: CIImage? {
        get {
            if let selectedImage = self.selectedImage {
                return CIImage(image: selectedImage)
            }else {
                return nil
            }
        }
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var blurredImageView: UIImageView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    //MARK: IBAction
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
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
            self.removeRectangles()
            DispatchQueue.global(qos: .userInitiated).async {
                self.detectFaces()
            }
        }
    }
    
    func detectFaces() {
        if let ciImage = self.selectedCiImage {
            let detectFaceRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handlefaces)
            let requestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])

            do {
                try requestHandler.perform([detectFaceRequest])
            }catch {
                print(error)
            }
        }
    }
    
    func handlefaces(request: VNRequest, error: Error?) {
        if let faces = request.results as? [VNFaceObservation] {
            DispatchQueue.main.async {
                self.displayUI(for: faces)
            }
        }
    }
    
    func displayUI(for faces: [VNFaceObservation]) {
        if let faceImage = self.selectedImage {
            let imageRect = AVMakeRect(aspectRatio: faceImage.size, insideRect: self.selectedImageView.bounds)
            
            for face in faces {
                let w = face.boundingBox.size.width * imageRect.width
                let h = face.boundingBox.size.height * imageRect.height
                let x = face.boundingBox.origin.x * imageRect.width
                let y = imageRect.maxY - (face.boundingBox.origin.y * imageRect.height) - h
                
                let layer = CAShapeLayer()
                layer.frame = CGRect(x: x, y: y, width: w, height:  h)
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 1
                self.selectedImageView.layer.addSublayer(layer)
            }
        }
    }
    
    func removeRectangles() {
        if let sublayers = self.selectedImageView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
}
