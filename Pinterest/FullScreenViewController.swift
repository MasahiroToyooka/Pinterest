//
//  FullScreenViewController.swift
//  Pinterest
//
//  Created by 豊岡正紘 on 2019/05/18.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {
    
    var dismissHandler: (() ->())?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCloseButton()
        view.backgroundColor = .yellow
    }
    
    fileprivate func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
}
