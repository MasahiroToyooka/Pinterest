//
//  ViewController.swift
//  Pinterest
//
//  Created by 豊岡正紘 on 2019/03/08.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        
        
        setupNavigationItem()
    }
    
    fileprivate func setupNavigationItem() {
        
        navigationItem.title = "ホーム"
        
        let image = #imageLiteral(resourceName: "image").withRenderingMode(.alwaysOriginal)
        let customView = UIButton(type: .system)
        
        customView.addTarget(self, action: #selector(handleOpen), for: .touchUpInside)
        customView.setImage(image, for: .normal)
        customView.imageView?.contentMode = .scaleAspectFit
        customView.layer.cornerRadius = 20
        customView.clipsToBounds = true
        customView.layer.borderWidth = 0.5
        customView.layer.borderColor = UIColor.lightGray.cgColor
        customView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let barButtonItem = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 40
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    @objc func handleOpen() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
}


extension ViewController: CustomDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt IndexPath: IndexPath) -> CGFloat {
    
        return CGFloat((arc4random_uniform(11) + 1)*20)
    }
}

extension UIColor {
    static var randomColor: UIColor {
        let r = CGFloat.random(in: 0 ... 255) / 255.0
        let g = CGFloat.random(in: 0 ... 255) / 255.0
        let b = CGFloat.random(in: 0 ... 255) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
