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
    func didSelectItem(at indexPath: IndexPath) -> PhotoModel
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
    var nextPage: Int { currentPage + 1 }
     
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
        loading = .none
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
    
    func getViewModel(for indexPath: IndexPath) -> PhotoListItemViewModel {
        return PhotoListItemViewModel.init(photo: self.pages.photosSections[indexPath.section][indexPath.row])
    }
}


// MARK: - INPUT. View event methods
extension PhotosListViewModel {
    func viewDidLoad() {}
     
    func didSelectItem(at indexPath: IndexPath) -> PhotoModel {
        return pages.photosSections[indexPath.section][indexPath.row]
    }
    
    func didLoadNextPage() {
        guard self.loading == .none else {
            return
        }
        
        load(loading: .nextPage)
    }
}

// MARK: - Private

extension Array where Element == PhotosModel {
    var photos: [PhotoModel] { flatMap { $0.photos } }
    var photosSections: [[PhotoModel]] {photos.chunked(into: 5)}
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
