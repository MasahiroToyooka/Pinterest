//
//  ViewController.swift
//  Pinterest
//
//  Created by 豊岡正紘 on 2019/03/08.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UIGestureRecognizerDelegate{

    var fullScreenViewController: FullScreenViewController!
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        collectionView.backgroundColor = .white
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        
        
        setupNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateCollectionView()
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeViewCell
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showSingleAppFullscreen(indexPath: indexPath)
    }
    
  
    fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let fullScreenViewController = FullScreenViewController()
//        fullScreenViewController.todayItem = items[indexPath.row]
        fullScreenViewController.dismissHandler = {
            self.handleAppFullscreenDismissal()
        }
        
        fullScreenViewController.view.layer.cornerRadius = 16
        self.fullScreenViewController = fullScreenViewController
//
//        // #1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        fullScreenViewController.view.addGestureRecognizer(gesture)
        
        // #2 add a blue effect view
        
        // #3 not to interfere with our UITableView scrolling
    }
    
    var anchoredConstraints: AnchoredConstraints?
    var startingFrame: CGRect?
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // absolute coordindates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        let fullscreenView = fullScreenViewController.view!
        view.addSubview(fullscreenView)

        addChild(fullScreenViewController)

        self.collectionView.isUserInteractionEnabled = false

        setupStartingCellFrame(indexPath)

        guard let startingFrame = self.startingFrame else { return }

        self.anchoredConstraints = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1

            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height

            self.view.layoutIfNeeded() // starts animation

//
//            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            
//
//            cell.todayCell.topConstraint.constant = 48
//            cell.layoutIfNeeded()
            
            
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullscreen(indexPath: IndexPath) {
        // #1
        setupSingleAppFullscreenController(indexPath)

        // #2 setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)

        // #3 begin the fullscreen animation
        beginAnimationAppFullscreen()
    }
    
    var fullscreenBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
//            appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
            //            print(appFullscreenBeginOffset)
        }
        
//        if appFullscreenController.tableView.contentOffset.y > 0 {
//            return
//        }
        
        let translationY = gesture.translation(in: fullScreenViewController.view).y
        print(translationY)
        
        if gesture.state == .changed {
            if translationY > 0 {
//                let trueOffset = translationY - appFullscreenBeginOffset
//
//                var scale = 1 - trueOffset / 1000
//
//                print(trueOffset, scale)
//
//                scale = min(1, scale)
//                scale = max(0.5, scale)
//
//                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
//                self.fullScreenViewController.view.transform = transform
            }
            
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleAppFullscreenDismissal()
            }
        }
    }
    
    @objc func handleAppFullscreenDismissal() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.fullScreenViewController.view.transform = .identity
//
//            self.appFullscreenController.tableView.contentOffset = .zero
            
            guard let startingFrame = self.startingFrame else { return }
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.tabBarController?.tabBar.transform = .identity
            
//            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            //            cell.closeButton.alpha = 0
            self.fullScreenViewController.closeButton.alpha = 0
//            cell.todayCell.topConstraint.constant = 24
//            cell.layoutIfNeeded()
            
        }, completion: { _ in
            self.fullScreenViewController.view.removeFromSuperview()
            self.fullScreenViewController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    @objc func handleOpen() {
        (UIApplication.shared.keyWindow?.rootViewController as? BaseSlidingController)?.openMenu()
    }
    
    func animateCollectionView() {
        print(123)
        let cells = collectionView.visibleCells
                let collectionViewHeight = collectionView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: collectionViewHeight)
        }
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.6, delay: Double(delayCounter)  * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = .identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}


extension HomeController: CustomDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt IndexPath: IndexPath) -> CGFloat {
    
        return CGFloat((arc4random_uniform(11) + 1)*20)
    }
}



