//
//  FiltersViewController.swift
//  Instalog
//
//  Created by Dimon on 17.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var filtersCollection: UICollectionView!
    
    // MARK: - Properties
    
    var photo: UIImage?
    var thumbnailPhoto: UIImage?
    private let filtersShareSegue = "FiltersShareSegue"
    private let backgroundQueue = DispatchQueue(label: "backgroundQueue",
                                                qos: .background,
                                                attributes: .concurrent)
    
    private let filters: [ImageFilter] = [
        Original(),
        GaussianBlurFilter(),
        NoirFilter(),
        SepiaFilter(),
        ColorInvertFilter(),
        VignetteFilter(),
    ]
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersCollection.dataSource = self
        filtersCollection.delegate = self
        
        imageView.backgroundColor = .systemGray
        if let photo = photo {
            imageView.image = photo
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
    }
    
    // MARK: - Objective-C Functions
    
    @objc func nextTapped() {
        performSegue(withIdentifier: filtersShareSegue, sender: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == filtersShareSegue,
           let destination = segue.destination as? PublicationViewController {
            destination.finalImage = imageView.image
        }
    }
}

    // MARK: - Collection View Data Source

extension FiltersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FiltersCollectionViewCell
        cell.filterNameLabel.text = filters[indexPath.row].name
        backgroundQueue.async {
            let filteredImage = self.thumbnailPhoto.flatMap(self.filters[indexPath.row].apply)
            DispatchQueue.main.async {
                cell.filterPreviewImage.image = filteredImage
            }
        }
        return cell
    }
}

    // MARK: - Collection View Delegate

extension FiltersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let loadingIndicator = LoadingIndicator(uiView: self.view)
        loadingIndicator.show()
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        backgroundQueue.async {
            let filteredImage = self.photo.flatMap(self.filters[indexPath.item].apply)
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
                loadingIndicator.hide()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}
