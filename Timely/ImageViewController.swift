//
//  ImageViewController.swift
//  Timely
//
//  Created by 张泽正 on 2019/6/13.
//  Copyright © 2019 monash. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // User can select photo in their phone and that will present to the image view.
    @IBAction func pickPhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // Photo will save to UserDefaults,
    // In DetailVC, it will set the wallpaper if UserDefaults("backgroundPicture") is not nil.
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage(title: "Error", message: "Cannot save until a photo has been taken!", pop: false)
            return
        }
        
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        
        UserDefaults.init(suiteName: "group.Cipher.Timely")?.setValue(data, forKey: "backgroundPicture")
        displayMessage(title: "Success!", message: "Image has been saved!", pop: true)
    }
    
    // Reset UserDefaults("backgroundPicture") to nil.
    @IBAction func reset(_ sender: Any) {
        UserDefaults.init(suiteName: "group.Cipher.Timely")?.setValue(nil, forKey: "backgroundPicture")
        displayMessage(title: "Success!", message: "Image has been reset!", pop: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        displayMessage(title: "Error", message: "There was an error in getting the image", pop: false)
    }
    
    func popHandler(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    func displayMessage(title: String, message: String, pop: Bool) {
        // Setup an alert to show user details about the Person
        let alertController = UIAlertController(title: title, message: message,preferredStyle: UIAlertController.Style.alert)
        
        // If use input correctly, the feedback will lead to the page before,
        // else if user get an error, it should stay in current page.
        // Writing handler for UIAlertAction: https://stackoverflow.com/questions/24190277/writing-handler-for-uialertaction
        
        if pop{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: popHandler))
        }
        else{
            alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertAction.Style.default,handler: nil))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

