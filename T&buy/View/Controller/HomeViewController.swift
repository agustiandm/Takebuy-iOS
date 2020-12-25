//
//  HomeViewController.swift
//  T&buy
//
//  Created by Agustian DM on 20/08/20.
//  Copyright © 2020 Agustian DM. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    var pageViewController: UIPageViewController?
    let arrPageImage = ["1","2","3"]
    var currentIndex = 0
    var categoryArray: [Category] = []
        
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HomeViewController.loadNextController), userInfo: nil, repeats: true)
        
        setpageViewController()
        setupUI()
        collectionView.delegate = self
        collectionView.dataSource = self
//        createCategorySet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryToItemsSeg" {
            let vc = segue.destination as! ItemsCollectionViewController
            vc.category = (sender as! Category)
        }
    }
    
    //MARK; - Selectors
    @objc private func loadNextController() {
        currentIndex += 1
        
        if currentIndex == arrPageImage.count {
            currentIndex = 0
        }
        
        let nextController = getViewController(atIndex: currentIndex)
        self.pageViewController?.setViewControllers([nextController], direction: .forward, animated: true, completion: nil)
        self.pageControl.currentPage = currentIndex
    }
    
    //MARK: - Helper
    private func setpageViewController() {
        let pageVC = self.storyboard?.instantiateViewController(identifier: "promoPageVC") as! UIPageViewController
        pageVC.dataSource = self
        
        let firstController = getViewController(atIndex: 0)
        
        pageVC.setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        self.pageViewController = pageVC
        self.addChild(self.pageViewController!)
        self.pageView.addSubview(self.pageViewController!.view)
        self.pageViewController?.didMove(toParent: self)
    }
    
    fileprivate func getViewController(atIndex index: Int) -> PromoContentViewController {
        let promoContenVC = self.storyboard?.instantiateViewController(identifier: "promoContentVC") as! PromoContentViewController
        promoContenVC.imageName = arrPageImage[index]
        promoContenVC.pageIndex = index
        return promoContenVC
        
    }
    
    private func loadCategories() {
        downloadCategoriesFromFirebase { (allCategories) in
//            print("DEBUG: we have category \(allCategories.count)")
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    func setupUI() {
        pageView.layer.cornerRadius = 10
        pageView.clipsToBounds = true
    }
}

//MARK: - UIPageViewControllerDataSource
extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageContentVC = viewController as! PromoContentViewController
        var index = pageContentVC.pageIndex
        
        if index == 0 || index == NSNotFound {
            return getViewController(atIndex: arrPageImage.count - 1)
        }
        
        index -= 1
        return getViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageContentVC = viewController as! PromoContentViewController
        var index = pageContentVC.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == arrPageImage.count {
            return getViewController(atIndex: 0)
        }
        
        return getViewController(atIndex: index)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItemsSeg", sender: categoryArray[indexPath.row])
    }
    
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.generateCell(categoryArray[indexPath.row])
    
        return cell
    }
    
}

