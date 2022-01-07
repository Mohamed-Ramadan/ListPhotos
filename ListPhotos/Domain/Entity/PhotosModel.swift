//
//  PhotosModel.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation

struct PhotosModel {
    let page: Int
    let photos: [PhotoModel]
}

// MARK: - PhotoModel
struct PhotoModel {
    let id, author: String
    let url, downloadURL: String
}
   
