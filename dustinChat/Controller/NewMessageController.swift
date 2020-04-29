//
//  NewMessageController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/27.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

private let resueIdentifier = "UserCell"


//#1 Protocol
protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}


class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()
    //#2 Protocol
    weak var delegate: NewMessageControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureUI()
        fetchUsers()
    }
    
    //MARK: - Helpers
    func configureUI() {
        
       
        
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismiss))
            
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: resueIdentifier)
        tableView.rowHeight = 80
        
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        
        //이렇게 하면 searchbar click시에 navigation bar로 searchcontroller가 들어감.
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        //아래의 메소드 추가해주면 navigation title이 사라지지 않는다.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a User"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemTeal
            textField.backgroundColor = .white
        }
    }
    
    
    //MARK: - API
    
    //#3 fectch User Data
    func fetchUsers() {
        showLoader(true)
        Service.fetchUser { users in
            self.users = users
            // 처음에 tableview가 켜지면, user -> 아무것도 없음 (API에서 Data가져오기 전)
            //그래서 reload 함.
            self.showLoader(false)
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
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifier, for: indexPath) as! UserCell
        
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]

        
        
        return cell
    }
    
}


extension NewMessageController {
    //#3 Protocol
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToStartChatWith: user)
        
    }
}

extension NewMessageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        //한글자씩 확인한다.
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ user -> Bool in
            return user.username.contains(searchText)
            || user.fullname.contains(searchText)
           
        })
         self.tableView.reloadData()
    }

}
