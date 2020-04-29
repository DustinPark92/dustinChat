//
//  ProfileFooter.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/29.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

protocol ProfileFooterDelegate : class {
    func handleLogOut()
}

class ProfileFooter: UIView {
    
    //MARK: - Properties
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor , paddingLeft: 32 , paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc func handleLogOut() {
        delegate?.handleLogOut()
    }
    
    
}
