//
//  CreatePostController.swift
//  miniGram
//
//  Created by Ashiq Uz Zoha on 3/6/23.
//

import UIKit
import ActionKit

class CreatePostController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTextView.text = ""
        self.contentButton.addControlEvent(.touchUpInside) {
            
            let controller = UIAlertController(title: "Pick Image", message: "Please choose an image", preferredStyle: .actionSheet)
            let cameraButton = UIAlertAction(title: "Use Camera", style: .default) { _ in
                print("camera button clicked")
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePickerController = UIImagePickerController()
                    self.imagePickerController.sourceType = .camera
                    self.imagePickerController.cameraCaptureMode = .video
                    self.imagePickerController.allowsEditing = true
                    self.imagePickerController.delegate = self
                    self.present(self.imagePickerController, animated: true)
                } else {
                    MinigramApp.showAlert(from: self, title: "Camera Not Available", message: "This device does not have a camera.")
                }
            }
            let galleryButton = UIAlertAction(title: "Select From Gallery", style: .default) { _ in
                print("gallery button clicked")
                self.imagePickerController = UIImagePickerController()
                self.imagePickerController.sourceType = .photoLibrary
                self.imagePickerController.allowsEditing = true
                self.imagePickerController.delegate = self
                self.present(self.imagePickerController, animated: true)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                print("cancel button clicked")
            }
            controller.addAction(cameraButton)
            controller.addAction(galleryButton)
            controller.addAction(cancelButton)
            self.present(controller, animated: true)
        }
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        imagePickerController.takePicture()
    }
}

extension CreatePostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey : Any]) {
        
        print("didFinishPickingMediaWithInfo")
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.contentImage.image = image
        
        /*
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
         */

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
