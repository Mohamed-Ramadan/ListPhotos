//
//  PhotosRepository.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation

protocol PhotosRepository {
     
    func getPhotos(limit: Int, page: Int,
                   cached: @escaping (PhotosModel) -> Void,
                   completion: @escaping (Result<PhotosResponseDTO, Error>) -> Void)
    
    func savePhotos(limit: Int, page: Int,
                    photosDTO: PhotosResponseDTO)
}
