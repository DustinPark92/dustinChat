//
//  profilerHeader.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/29.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit


protocol profileHeaderDelegate: class {
    func dismissController()
}

class profileHeader: UIView {
    //MARK: - Properties
    var user: User? {
        didSet { populateUserData() }
    }
    weak var delegate: profileHeaderDelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDissmissal), for: .touchUpInside)
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemTeal
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Dustin Park"
        return label
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Dustin"
        return label
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    @objc func handleDissmissal() {
 
        delegate?.dismissController()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        configureGradientLayer()
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor , paddingTop:  96)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft:  12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        
        gradient.locations = [0, 0.8]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    func populateUserData() {
        guard let user = user else { return }
        
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        
        profileImageView.sd_setImage(with: url)
    }
    
    
    
    
}
