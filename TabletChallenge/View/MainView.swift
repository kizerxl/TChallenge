//
//  ViewController.swift
//  TabletChallenge
//
//  Created by Felix Changoo on 4/8/19.
//  Copyright © 2019 Felix Changoo. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var previousRun = Date()
    private let minInterval = 0.05
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var presenter: MainPresenter!
    private var service: NasaService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setupSearchBar()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "ImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCell")
        
        service = NasaService()
        presenter = MainPresenter(presenterDelegate: self, nasaService: service)
    }
    
    private func setupSearchBar() {
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.titleView = searchController.searchBar
    }
}

extension MainView: MainPresenterDelegate {
    func onfetchImagesSuccess() {
        collectionView.reloadData()
    }
    
    func onfetchImagesFailed() {
        let alert = UIAlertController(title: "Image Loading Failed", message: "Failed to load images", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func onfetchMoreImages() {
        collectionView.reloadData()
    }
}

extension MainView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.nasaImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        if let img = presenter?.nasaImages[indexPath.row] {
            cell.configure(with: img)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = presenter?.nasaImages[indexPath.row]

        let controller =  self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailView
        controller.image = image
        
        self.navigationController?.pushViewController(controller, animated:true)
    }
}

extension MainView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + 200 >= scrollView.contentSize.height) {
            self.presenter?.loadMoreImages()
        }
    }
}

extension MainView: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            presenter?.clearImages()
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            presenter?.fetchImages(for: textToSearch)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clearImages()
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width / 4) - 16, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}


