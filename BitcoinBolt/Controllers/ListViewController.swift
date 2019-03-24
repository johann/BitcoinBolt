//
//  ListViewController.swift
//  BitcoinBolt
//
//  Created by Johann Kerr on 3/23/19.
//  Copyright © 2019 Johann Kerr. All rights reserved.
//

import UIKit

class ListViewController: UICollectionViewController {
    
    var prices = [DatePrice]()
    let store = DataStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        setupCollectionViewLayout()
        self.setupList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBarMargin()
        setupHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let timer = store.homeTimer else { return }
        timer.invalidate()
    }
    
    // MARK: View Helpers
    
    func setupHeader() {
        store.fetchCurrentPriceAtInterval {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupList() {
        store.fetchPastPrices {
            guard let prices = self.store.pricesByCurrency[Constants.defaultCurrency] else { return }
            self.prices = prices
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func setupCollectionViewLayout() {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        layout.minimumLineSpacing = 2
    }
    
    @objc func showDetailView() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        guard let currencyController = storyboard.instantiateViewController(withIdentifier: "currencyController") as? CurrencyViewController else { return }
        currencyController.prices = self.store.currentPriceByCurrency
        
        
        self.present(currencyController, animated: true, completion: nil)
    }
}

extension ListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RateCell else { fatalError("invalid cell") }
        let datePrice = self.prices[indexPath.row]
        cell.configureCell(datePrice)
        

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "headerView",
                    for: indexPath) as? HeaderView
                else { fatalError("Invalid view type") }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDetailView))
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
        print("Loading screen")
        let prices = self.store.fetchPricesAtIndex(indexPath.row)
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        guard let currencyController = storyboard.instantiateViewController(withIdentifier: "currencyController") as? CurrencyViewController else { return }
        currencyController.prices = prices


        self.present(currencyController, animated: true, completion: nil)
        
    }
}
