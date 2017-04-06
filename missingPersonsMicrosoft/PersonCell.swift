//
//  PersonCell.swift
//  missingPersonsMicrosoft
//
//  Created by Sukrit Gulati on 4/4/17.
//  Copyright © 2017 Sukrit Gulati. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    var person: Person!
    
    func configureCell(person: Person) {
        self.person = person
        if let url = URL(string: "\(baseURL)\(person.personImageUrl!)"){
            downlaoadImage(url: url)
        }
    }
    
    func downlaoadImage(url: URL){
        getDataFromUrl(url: url) { (data, response, error) in
            DispatchQueue.main.async(){
                guard let data = data, error == nil else {return}
                self.personImage.image = UIImage(data: data)
                self.person.personImage = self.personImage.image
                print("sukrit")
            }
        }
    
    }
    
    func getDataFromUrl(url: URL, completion: @escaping ((Data?, URLResponse?, Error?) ->Void)) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func setSelected(){
        personImage.layer.borderWidth  = 2.0
        personImage.layer.borderColor = UIColor.yellow.cgColor
        
        self.person.downloadFaceId()
    }
}

