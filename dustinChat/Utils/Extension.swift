//
//  Extension.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/23.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit
import JGProgressHUD


extension UIView {
    func anchor(top:NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom:NSLayoutYAxisAnchor? = nil,
                right:NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
            height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
                   leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
               }
        if let bottom = bottom  {
                   bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
               }
        if let right = right {
                   rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
               }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    
    }
    
    
    func centerX(inView view:UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func centerY(inView view:UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddigLeft: CGFloat = 0 , constatnt: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constatnt).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left , paddingLeft:  paddigLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height:CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width:CGFloat) {
           translatesAutoresizingMaskIntoConstraints = false
           heightAnchor.constraint(equalToConstant: width).isActive = true
       }
    
    

    
    
}

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
           let gradient = CAGradientLayer()
           gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
           gradient.locations = [0, 0.8]
           view.layer.addSublayer(gradient)
           gradient.frame = view.frame
           
       }
    
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        //JGProgressHuD
        view.endEditing(true)

        UIViewController.hud.textLabel.text = text
        
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        
    }

    
    
}
