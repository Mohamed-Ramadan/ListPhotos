//
//  PhotosUseCaseTests.swift
//  ListPhotosTests
//
//  Created by Mohamed Ramadan on 09/01/2022.
//

import XCTest
@testable import ListPhotos

class PhotosUseCaseTests: XCTestCase {

    var photosUSeCase: PhotosUseCase!
    var repository: PhotosRepository!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = DefaultPhotosRepositoryImplementer()
        photosUSeCase = DefaultPhotosUseCase(photosRepository: repository)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_fetchPhotosOfPageOne() {
        // arrange
        let photoRequestValue = PhotosRequestValue(page: 1, limit: 10)
        
        // Act
        photosUSeCase.fetchPhotos(requestValue: photoRequestValue) { cachedPhotos in
            
            // Assert
            XCTAssertNotNil(cachedPhotos, "Cached photos is Nil")
            XCTAssertLessThanOrEqual(cachedPhotos.photos.count, photoRequestValue.limit)
            XCTAssertEqual(cachedPhotos.page, photoRequestValue.page)
            
        } completion: { result in
            switch result {
                case .success(let photos):
                    
                    // Assert
                    XCTAssertNotNil(photos, "Photos is Nil")
                    XCTAssertLessThanOrEqual(photos.photos.count, photoRequestValue.limit)
                    XCTAssertEqual(photos.page, photoRequestValue.page)
                    break
                case .failure(let error):
                    // Assert
                    XCTAssertNotNil(error, "Error is Nil")
                    break
            }
        }

    }

}
