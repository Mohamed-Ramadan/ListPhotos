//
//  PhotosListViewModel.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import Foundation
 
enum PhotosListViewModelLoading {
   case fullScreen
   case nextPage
   case none
}

protocol PhotosListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSelectItem(at index: Int) -> PhotoModel
}


class PhotosListViewModel: PhotosListViewModelInput {
    
    private(set) var photosUseCase: PhotosUseCase
    var pages: [PhotosModel] = [] {
        didSet{
            self.photosCompletionHandler()
        }
    }
    
    private(set) var totalPhotos = 1
    private(set) var pageSize = 10
    private(set) var currentPage = 0
    var hasMorePages: Bool { (currentPage * pageSize) < totalPhotos }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
     
    private(set) var loading: PhotosListViewModelLoading = .none {
        didSet {
            self.loadingCompletionHandler(loading)
        }
    }
     
    var error:(_ errMsg: String)->() = {_ in}
    var photosCompletionHandler: ()->() = {}
    var loadingCompletionHandler:(_ loading: PhotosListViewModelLoading) -> () = {_ in}
    
    //MARK: - init
    init(photosUseCase: PhotosUseCase) {
        self.photosUseCase = photosUseCase
    }
    
    //MARK:- Private
    private func appendPage(_ page: PhotosModel) { 
        currentPage = page.page
        
        pages = pages
            .filter { $0.page != page.page }
            + [page]
    }
     
    private func load(loading: PhotosListViewModelLoading) {
        
        self.loading = loading
        let request = PhotosRequestValue(page: nextPage, limit: pageSize)
        
        photosUseCase.fetchPhotos(requestValue: request, cached: appendPage) { (result) in
            self.loading = .none
            
            switch result {
            case .success(let photosPage):
                self.appendPage(photosPage)
            case .failure(let error):
                self.error(error.localizedDescription)
            }
        }
    }
   
    private func resetPages() {
        currentPage = 0
        totalPhotos = 1
        pages.removeAll()
    }
    
    func update() {
        resetPages()
        
        load(loading: .fullScreen)
    }
    
    func getViewModel(for index: Int) -> PhotoListItemViewModel {
        return PhotoListItemViewModel.init(photo: self.pages.photos[index])
    }
}


// MARK: - INPUT. View event methods
extension PhotosListViewModel {
    func viewDidLoad() {}
     
    func didSelectItem(at index: Int) -> PhotoModel {
        return pages.photos[index]
    }
    
    func didLoadNextPage() {
        guard hasMorePages, self.loading == .none else {
            self.loading = .none
            return
        }
        
        load(loading: .nextPage)
    }
}

// MARK: - Private

extension Array where Element == PhotosModel {
    var photos: [PhotoModel] { flatMap { $0.photos } }
}


