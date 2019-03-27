//
//  ListViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/23/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit
import BitcoinKit

class ListViewController: UICollectionViewController {
    
    var rates = [DatePrice]()
    let store = DataStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        setupCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBarMargin()
        self.setupList()
        self.setupHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let timer = store.homeTimer else { return }
        timer.invalidate()
    }
    
    
    func setupList() {
        store.fetchPastPrices {
            guard let rates = self.store.pricesByCurrency[Constants.defaultCurrency] else { return }
            self.rates = rates
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupHeader() {
        store.fetchCurrentPriceAtInterval {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: View Helpers
    
    func setupCollectionViewLayout() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        layout.minimumLineSpacing = 2
    }
    
    @objc func showDetailViewForHeader() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        guard let currencyController = storyboard.instantiateViewController(withIdentifier: Constants.currencyControllerIdentifier) as? CurrencyViewController else { return }
        currencyController.rates = self.store.currentPriceByCurrency
        
        self.present(currencyController, animated: true, completion: nil)
    }
}

// MARK: CollectionView DataSource

extension ListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rates.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.rateCellIdentifier, for: indexPath) as? RateCell else { fatalError("invalid cell") }
        
        let datePrice = self.rates[indexPath.row]
        cell.configureCell(datePrice)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: Constants.headerView,
                    for: indexPath) as? HeaderView
                else { fatalError("Invalid view type") }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetailViewForHeader))
            headerView.addGestureRecognizer(tapGestureRecognizer)
            
            if let price = self.store.currentPrice {
                headerView.rateLabel.text = price.eurPrice.priceWithCurrencyCode
            }
            
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}

extension ListViewController  {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prices = self.store.fetchPricesAtIndex(indexPath.row)
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        guard let currencyController = storyboard.instantiateViewController(withIdentifier: Constants.currencyControllerIdentifier) as? CurrencyViewController else { return }
        currencyController.rates = prices


        self.present(currencyController, animated: true, completion: nil)
        
    }
}
