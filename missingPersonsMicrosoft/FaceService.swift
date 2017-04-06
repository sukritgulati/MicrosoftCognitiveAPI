//
//  FaceService.swift
//  missingPersonsMicrosoft
//
//  Created by Sukrit Gulati on 4/5/17.
//  Copyright © 2017 Sukrit Gulati. All rights reserved.
//

import Foundation
import ProjectOxfordFace

class FaceService {
    static let instance = FaceService()
    
    let client = MPOFaceServiceClient(subscriptionKey: "98792d724b564437a2ddac8ee0fad69a")
}
