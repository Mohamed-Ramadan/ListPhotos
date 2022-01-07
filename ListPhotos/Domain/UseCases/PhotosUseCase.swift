//
//  PhotosUseCase.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation
 
protocol PhotosUseCase {
    func fetchPhotos(requestValue: PhotosRequestValue,
                     cached: @escaping (PhotosModel) -> Void,
                     completion: @escaping (Result<PhotosModel, Error>) -> Void)
}

final class DefaultPhotosUseCase: PhotosUseCase {
     
    private let photosRepository: PhotosRepository
    
    init(photosRepository: PhotosRepository) {
        self.photosRepository = photosRepository
    }
    
    func fetchPhotos(requestValue: PhotosRequestValue, cached: @escaping (PhotosModel) -> Void, completion: @escaping (Result<PhotosModel, Error>) -> Void) {
        
        return self.photosRepository.getPhotos(limit: requestValue.limit, page: requestValue.page,
                                               cached: cached) { (result) in
            
            switch result {
                case .success(let model):
                    
                    // only cache first 20 photos
                    if (requestValue.page * requestValue.limit) <= 20 {
                        self.photosRepository.savePhotos(limit: requestValue.limit, page: requestValue.page,
                                                         photosDTO: model)
                    }
                    
                    completion(.success(model.toDomain(page: requestValue.page)))
                    
                case .failure(let error):
                    completion(.failure(error))
            }
         }
    }
}

struct PhotosRequestValue {
    let page: Int
    let limit: Int
}
