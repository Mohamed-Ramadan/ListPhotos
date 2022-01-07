//
//  DefaultPhotosCoreDataStorage.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import CoreData
 
final class DefaultPhotosCoreDataStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    private func fetchRequest(for requestDto: PhotosRequestDTO) -> NSFetchRequest<PhotosRequestEntity> {
        let request: NSFetchRequest = PhotosRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(PhotosRequestEntity.limit), requestDto.limit,
                                        #keyPath(PhotosRequestEntity.page), requestDto.page)
        return request
    }

    private func deleteResponse(for requestDto: PhotosRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension DefaultPhotosCoreDataStorage: PhotosResponseStorage {

    func getResponse(for requestDTO: PhotosRequestDTO, completion: @escaping (Result<PhotosResponseDTO?, CoreDataStorageError>) -> Void) {
        
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDTO)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
        
    }
    
    func save(responseDTO: PhotosResponseDTO, for requestDTO: PhotosRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDTO, in: context)

                let requestEntity = requestDTO.toEntity(in: context)
                requestEntity.response = responseDTO.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
