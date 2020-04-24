//
//  RegisterationController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/23.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit



class RegisterationController: UIViewController {
    
    
    //MARK: - Properties
    
    private var viewModel = RegisterationViewModel()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        return button
        
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x")!, textField: emailTextField)

    }()
    
    private lazy var  fullNameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x")!, textField: fullNameTextField)
        
     }()
    
    private lazy var  userNameContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "ic_person_outline_white_2x")!, textField: userNameTextField)
        
     }()
    
    private lazy var  passwordContainerView: UIView = {
        return InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x")!, textField: passwordTextField)
        
     }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    
    private let userNameTextField  = CustomTextField(placeholder: "User Name")
      
    private let passwordTextField: CustomTextField = {
          let tf = CustomTextField(placeholder: "Password")
          tf.isSecureTextEntry = true
          return tf
      }()
    
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action:#selector(handleSignUp), for: .touchUpInside)
     
        return button
    }()
    
    private let alreadyHaveAccount: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Do you have an account?", attributes:
            [.font : UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white] )
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                        .foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Selector
    @objc func handleSelectPhoto() {
        
          let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func handleSignUp() {
        print(123)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
        
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == userNameTextField {
            viewModel.username = sender.text
        } else if sender == fullNameTextField {
        viewModel.fullname = sender.text
     
    }
         checkFormStatus()
    }
    
    //MARK: - Selctor
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   userNameContainerView,
                    
                                                   passwordContainerView,
                                                   signUpButton])
        
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.spacing = 16
        
        
        stack.anchor(top: plusPhotoButton.bottomAnchor , left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32 , paddingRight:  32)
        
        
        view.addSubview(alreadyHaveAccount)
        alreadyHaveAccount.anchor(left: view.leftAnchor , bottom:view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
        
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
         passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
         userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    

    

}
//MARK : - UIImagePickerControllerDelegate
extension RegisterationController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
        
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterationController : AuthenticationControllerProtocol {
    
    
    func checkFormStatus() {
              if viewModel.fromIsValid {
                  signUpButton.isEnabled = true
                  signUpButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
              } else {
                  signUpButton.isEnabled = false
                  signUpButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
                  
              }
              
          }
    
    
}
