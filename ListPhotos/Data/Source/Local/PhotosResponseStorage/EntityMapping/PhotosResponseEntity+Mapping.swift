//
//  PhotosResponseEntity+Mapping.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import CoreData

//MARK: - Mapping To Data Transfer Object
extension PhotosResponseEntity {
    func toDTO() -> PhotosResponseDTO {
        return photos?.map{($0 as! PhotoResponseEntity).toDTO()} ?? []
    }
}

extension PhotoResponseEntity {
    func toDTO() -> PhotoDTO {
        return .init(id:id ?? "",
                     author: author ?? "",
                     url: url ?? "",
                     downloadURL: downloadUrl ?? "")
    }
}


// Mapping to Entity Model
extension PhotosRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> PhotosRequestEntity {
        let entity: PhotosRequestEntity = .init(context: context)
        
        entity.page = Int32(page)
        entity.limit = Int32(limit)
        
        return entity
    }
}

extension PhotosResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> PhotosResponseEntity {
        let entity: PhotosResponseEntity = .init(context: context)
        
        self.forEach {
            entity.addToPhotos($0.toEntity(in: context))
        }
        
        return entity
    }
}

extension PhotoDTO {
    func toEntity(in context: NSManagedObjectContext) -> PhotoResponseEntity {
        let entity: PhotoResponseEntity = .init(context: context)
        
        entity.id = id
        entity.author = author
        entity.url = url
        entity.downloadUrl = downloadURL
        
        return entity
    }
}
