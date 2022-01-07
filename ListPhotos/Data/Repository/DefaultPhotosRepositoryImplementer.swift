//
//  DefaultPhotosRepositoryImplementer.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation

final class DefaultPhotosRepositoryImplementer: PhotosRepository {
    
    private let photosStorage : PhotosResponseStorage
    private let networkService: NetworkService
    
    init(photosStorage : PhotosResponseStorage = DefaultPhotosCoreDataStorage(), networkService: NetworkService = URLSessionNetworkService()) {
        self.photosStorage = photosStorage
        self.networkService = networkService
    }
    
    func getPhotos(limit: Int, page: Int, cached: @escaping (PhotosModel) -> Void, completion: @escaping (Result<PhotosResponseDTO, Error>) -> Void) {
        let requestDTO = PhotosRequestDTO(page: page, limit: limit)
        
        // load photos from cache storage
        photosStorage.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
        }
        
        // load photos from remote service
        networkService.getPhotos(request: requestDTO, completion: completion)
    }
    
    func savePhotos(limit: Int, page: Int, photosDTO: PhotosResponseDTO) {
        let requestDTO = PhotosRequestDTO(page: page, limit: limit) 
        photosStorage.save(responseDTO: photosDTO, for: requestDTO)
    }
}

