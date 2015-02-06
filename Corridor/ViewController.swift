//
//  ViewController.swift
//  Corridor
//
//  Created by Greg Olmschenk on 1/29/15.
//  Copyright (c) 2015 Greg Olmschenk. All rights reserved.
//


import UIKit


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var frame: UIImage!
    var imagePicker: UIImagePickerController!

    @IBAction func loadImageButton() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func processFrameButton() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        frame = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
