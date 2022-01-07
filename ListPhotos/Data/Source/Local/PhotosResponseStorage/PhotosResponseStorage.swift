//
//  PhotosResponseStorage.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation


protocol PhotosResponseStorage {
   func getResponse(for requestDTO: PhotosRequestDTO, completion: @escaping (Result<PhotosResponseDTO?, CoreDataStorageError>) -> Void)
   func save(responseDTO: PhotosResponseDTO, for requestDTO: PhotosRequestDTO)
}
