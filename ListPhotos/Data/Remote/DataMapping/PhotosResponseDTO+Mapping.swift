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
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
   
//MARK: Mapping To Domain
extension PhotosResponseDTO {

}

extension PhotoDTO {

}
