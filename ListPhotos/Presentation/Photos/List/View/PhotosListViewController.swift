//
//  PhotosListViewController.swift
//  ListPhotos
//
//  Created by Mohamed Ramadan on 07/01/2022.
//

import UIKit

class PhotosListViewController: UIViewController {

    static let identifier = "PhotosListViewController"
    
    @IBOutlet weak var photosTableView: UITableView!
    
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var fullPageLoadingSpinner: UIActivityIndicatorView?
    
    var viewModel: PhotosListViewModel!
    private lazy var photosUseCase: PhotosUseCase = {
        let photosRepository: PhotosRepository = DefaultPhotosRepositoryImplementer()
        return DefaultPhotosUseCase(photosRepository: photosRepository)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupUI()
        bindViewModel()
        loadData()
    }
    
    //MARK: - Private Methods
    private func loadData() {
        self.viewModel.update()
    }
    
    private func bindViewModel() {
        self.viewModel = PhotosListViewModel(photosUseCase: photosUseCase)
         
        self.viewModel.photosCompletionHandler = {
            DispatchQueue.main.async {
                self.photosTableView.reloadData()
            }
        }
        
        self.viewModel.loadingCompletionHandler = { [weak self] in
            guard let self = self else {
                return
            }
             
            self.updateLoading($0)
        }
        
        self.viewModel.error = { errorMsg in
            self.showAlert(with: errorMsg)
        }
    }
     
    private func updateLoading(_ loading: PhotosListViewModelLoading) {
        DispatchQueue.main.async {
            switch loading {
                case .fullScreen: self.handleFullPageLoading(isAnimating: true)
                case .nextPage, .none: self.handleFullPageLoading(isAnimating: false)
            }
            
            self.updateTableViewFooterLoading(loading)
        }
    }
    
    private func handleFullPageLoading(isAnimating: Bool) {
        if isAnimating {
            fullPageLoadingSpinner?.removeFromSuperview()
            fullPageLoadingSpinner = self.makeActivityIndicator(size: .init(width: self.view.frame.width, height: 44))
            self.view.addSubview(fullPageLoadingSpinner!)
            fullPageLoadingSpinner?.center = self.view.center
            fullPageLoadingSpinner?.startAnimating()
        } else {
            fullPageLoadingSpinner?.removeFromSuperview()
        }
    }
    
    func updateTableViewFooterLoading(_ loading: PhotosListViewModelLoading) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = photosTableView.makeActivityIndicator(size: .init(width: photosTableView.frame.width, height: 44))
            photosTableView.tableFooterView = nextPageLoadingSpinner
            case .fullScreen, .none:
                photosTableView.tableFooterView = nil
        }
    }
    
    private func setupUI () {
        self.title = "Photos"
    }
    
    private func setupTableView() {
        self.photosTableView.register(PhotoListItemTableViewCell.nib(), forCellReuseIdentifier: PhotoListItemTableViewCell.identifier)
        
        self.photosTableView.delegate = self
        self.photosTableView.dataSource = self
        self.photosTableView.separatorStyle = .none
    }

}


extension PhotosListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.pages.photosSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.pages.photosSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListItemTableViewCell.identifier, for: indexPath) as? PhotoListItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.configureCellWithPhoto(self.viewModel.getViewModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPhoto = self.viewModel.didSelectItem(at: indexPath)
        
        let photoPreviewViewController = PhotoPreviewViewController(nibName: "PhotoPreviewViewController", bundle: nil)
        photoPreviewViewController.imageUrlString = selectedPhoto.downloadURL
        self.present(photoPreviewViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == self.viewModel.pages.photosSections.count-1 {
            self.viewModel.didLoadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        
        let label = UILabel()
        label.text = "Ad Placeholder"
        label.textColor = .white
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.viewModel.pages.photosSections[section].count < 5 {
            return 0
        }
        
        return 100
    }
}

