//
//  PhotoListItemViewModelTests.swift
//  ListPhotosTests
//
//  Created by Mohamed Ramadan on 09/01/2022.
//

import XCTest
@testable import ListPhotos

class PhotoListItemViewModelTests: XCTestCase {
 
    let photoModel = PhotoModel(id: "1",
                                author: "Mohamed",
                                url: "https://unsplash.com/photos/yC-Yzbqy7PY",
                                downloadURL: "https://picsum.photos/id/0/5616/3744")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
 
    // Test initialization of PhotoListItemViewModel not nil
    func test_initPhotoListItemViewModel() {
        let photoListItemViewModel = PhotoListItemViewModel(photo: photoModel)
        XCTAssertNotNil(photoListItemViewModel)
    }
    
    // Test photoID not empty
    func test_photoIDNotEmptyString() {
        let photoListItemViewModel = PhotoListItemViewModel(photo: photoModel)
        XCTAssertFalse(photoListItemViewModel.id.isEmpty)
    }
    
    // Test author name is equal Photo model author name
    func test_authorName_isEqual_initialize_authorName() {
        let photoListItemViewModel = PhotoListItemViewModel(photo: photoModel)
        XCTAssertEqual(photoModel.author, photoListItemViewModel.authorName)
    }
    
    // Test downloadURL is equal Photo model download URL
    func test_downloadURL_isEqual_initialize_downloadURL() {
        let photoListItemViewModel = PhotoListItemViewModel(photo: photoModel)
        XCTAssertEqual(photoModel.downloadURL, photoListItemViewModel.downloadUrl)
    }
    
    
}
