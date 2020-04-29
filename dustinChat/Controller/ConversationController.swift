//
//  ConversationController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/23.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


private let resueIdentifier = "ConversationCell"

class ConversationsController: UIViewController{
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationDictionary = [String:Conversation]()
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal )
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    

    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConversations()
        
  
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    //MARK:- Selectors
    
    @objc func showProfile() {
        
        // .insetGrouped 하니까 안으로 들어가네.
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self 
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
    }
    
    
    
    //MARK: - API
    
    func fetchConversations() {
        showLoader(true)
        
        Service.fetchConversations { conversations in
            
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationDictionary[message.chatPartnerId] = conversation
                
            }
            self.showLoader(false)
            self.conversations = Array(self.conversationDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        }
    }
    
    //MARK: - Helpers
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        
        view.backgroundColor = .white

    
        configureTableView()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor , right : view.rightAnchor,
                                paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: resueIdentifier)
        
        //tableview 나누는 선 없애 줌
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User) {
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("Error Sign out")
        }
        
    }



}

extension ConversationsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(conversations.count)
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifier, for: indexPath) as! ConversationCell
        
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
    
    
    
}

extension ConversationsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
    
    
}
// MARK: - NewMessageControllerDelegate

//#4 Protocol
extension ConversationsController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
       dismiss(animated: true, completion: nil)
        
        showChatController(forUser: user)

    }
    
    
}

//MARK: - ProfileControllerDelegate
extension ConversationsController: ProfileControllerDelegate {
    func handleLogOut() {
        logout()
    }
}

//MARK: - AuthenticationDelegate
extension ConversationsController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConversations()
    }

}

