//
//  ViewController.swift
//  missingPersonsMicrosoft
//
//  Created by Sukrit Gulati on 4/4/17.
//  Copyright © 2017 Sukrit Gulati. All rights reserved.
//

import UIKit
import ProjectOxfordFace 

let baseURL = "http://localhost:6069/img/"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var selectedIg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imagePicker = UIImagePickerController()
    var hasSelectedImg: Bool = false
    
    var selectedPerson: Person?
    
    let missingPeople1 = [
    "person1.jpg",
    "person2.jpg",
    "person3.jpg",
    "person4.jpg",
    "person5.jpg",
    "person6.png"
    ]
    let missingPeople = [
    Person(personImageUrl: "person1.jpg"),
    Person(personImageUrl: "person2.jpg"),
    Person(personImageUrl: "person3.jpg"),
    Person(personImageUrl: "person4.jpg"),
    Person(personImageUrl: "person5.jpg"),
    Person(personImageUrl: "person6.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(gesture:)))
        selectedIg.addGestureRecognizer(tap)

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        let person = missingPeople[indexPath.row]
        let url = "\(baseURL)\(missingPeople[indexPath.row])"
        cell.configureCell(person: person)
        return cell
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedIg.image = pickedImage
            hasSelectedImg = true
        }
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedPerson = missingPeople[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! PersonCell
        cell.configureCell(person: selectedPerson!)
        cell.setSelected()
    }
    
    func loadPicker(gesture: UITapGestureRecognizer) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person", message: "Please select a missing person to check", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
         self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject){
        if selectedPerson == nil || !hasSelectedImg {
         showErrorAlert()
           
        } else {
            if let myImg = selectedIg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
            
                FaceService.instance.client?.detect(with: imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces, error) in
                    if error == nil {
                        var faceId: String?
                        for face in faces! {
                            faceId = face.faceId
                            break
                        }
                        FaceService.instance.client?.verify(withFirstFaceId: self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result, error) in
                            if error == nil {
                                print(result?.confidence)
                                print(result?.isIdentical)
                            } else {
                                print(error.debugDescription)
                            }
                        })
                      
                        
                    }
                })
                
    
            }
        }
    }
}

