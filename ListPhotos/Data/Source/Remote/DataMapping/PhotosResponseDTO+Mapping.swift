//
//  PhotosResponseDTO+Mapping.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation
 
// MARK: - PhotosResponseDTO
typealias PhotosResponseDTO = [PhotoDTO]

// MARK: - PhotoDTO
struct PhotoDTO: Codable {
    let id, author: String 
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, url
        case downloadURL = "download_url"
    }
}
   
//MARK: Mapping To Domain
extension PhotosResponseDTO {
    func toDomain(page: Int) -> PhotosModel {
        return .init(page: page, photos: self.map{ $0.toDomain()})
    }
}

extension PhotoDTO {
    func toDomain() -> PhotoModel {
        return .init(id: id, author: author, url: url, downloadURL: downloadURL)
    }
}
