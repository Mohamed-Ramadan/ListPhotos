//
//  PhotoListItemViewModel.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation
 
struct PhotoListItemViewModel {
    var id: String = ""
    var authorName: String = ""
    var downloadUrl: String = ""
}

extension PhotoListItemViewModel {
    init(photo: PhotoModel) {
        self.authorName = photo.author
        self.downloadUrl = photo.downloadURL
        self.id = photo.id
    }
}
