//
//  LoginController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/23.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    //MARK: - Properties
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private let emailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        view.setHeight(height: 50)
        return view
    }()
    
    private let passwordContainerView: UIView = {
         let view = UIView()
         view.backgroundColor = .cyan
        view.setHeight(height: 50)
         return view
     }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemRed
        button.setHeight(height: 50)
        return button
    }()
    
    
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .systemPurple
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 50
        
        
        stack.anchor(top: iconImage.bottomAnchor , left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32 , paddingRight:  32)
        
        
    }
    
    //MARK: - Selector
    
    //gradation 넣기
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.locations = [0, 0.8]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
        
    }
}
