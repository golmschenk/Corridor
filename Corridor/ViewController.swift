//
//  ViewController.swift
//  Corridor
//
//  Created by Greg Olmschenk on 1/29/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//


import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var frame: Frame?
    var imagePicker: UIImagePickerController!

    @IBAction func loadImageButton() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func processFrameButton() {
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        frame = Frame(image: image)
        frame?.canny()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
