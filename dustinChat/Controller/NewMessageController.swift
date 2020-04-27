//
//  NewMessageController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/27.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

private let resueIdentifier = "UserCell"


class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    private var users = [User]()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        
        fetchUsers()
        
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
            
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: resueIdentifier)
        tableView.rowHeight = 80
        
    }
    
    
    
    //MARK: - API
    
    //#3 fectch User Data
    func fetchUsers() {
        Service.fetchUser { users in
            self.users = users
            // 처음에 tableview가 켜지면, user -> 아무것도 없음 (API에서 Data가져오기 전)
            //그래서 reload 함.
            self.tableView.reloadData()

        }
    }
    
    
    //MARK: - Selectors
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifier, for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]

        
        
        return cell
    }
    
}
