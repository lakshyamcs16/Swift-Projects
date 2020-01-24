//
//  InitialTestScreenVC.swift
//  Toolchecker
//
//  Created by Aashna Narula on 23/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

import UIKit

class InitialTestScreenVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: InitialTestScreenVM!
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = InitialTestScreenVM()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
extension InitialTestScreenVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewModel.array[indexPath.item] {
        case .singleTest:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Single Test")
            return cell
        case .runAllTest:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Run All Test")
            return cell
        case .deviceInfo:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Device Info")
            return cell
        case .checkIMEI:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Check IMEI")
            return cell
        case .testResults:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Test Results")
            return cell
        case .phoneCleaner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCellType", for: indexPath) as? TestCellType else {return UICollectionViewCell()}
            cell.layer.borderColor = UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0).cgColor
            cell.setupCell(name: "Phone Cleaner")
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch self.viewModel.array[indexPath.item] {
        case .singleTest:
            let vc = SingleTestListVC.newInstance()
            self.navigationController?.pushViewController(vc, animated: true)
        case .runAllTest:
            Tests.allTests(key: .gyroscope, this: self.navigationController!, runAllTests: true)
            break
        case .testResults:
            break
        case .deviceInfo:
            break
        case .checkIMEI:
            break
        case .phoneCleaner:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
