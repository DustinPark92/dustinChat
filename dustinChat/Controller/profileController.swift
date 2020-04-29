//
//  profileController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/29.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handleLogOut()
}

class ProfileController: UITableViewController {
    
    
    //MARK: - Properties
    weak var delegate : ProfileControllerDelegate?
    private var user: User? {
        didSet { headerView.user = user }
    }
    
    
    private lazy var headerView = profileHeader(frame: .init(x: 0, y: 0, width: view.frame.width , height: 400))
    
    private let footerView = ProfileFooter()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true

        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        showLoader(true)
        Service.fetchUser(withUid: uid) { user in
            self.user = user
            self.showLoader(false)
            print("\(user.username)")
        }
    }
    
    //MARK: - Helpers
    

    
    
    func configureUI() {
        
        headerView.delegate = self
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        //위에 상태창까지 다 채워준다.
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        //여기서 hegiht를 늘리니까 logout과 tableview사이가 벌어진다.
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        
        footerView.delegate = self
    
    }
    
    
    
    
}

//MARK: - UItableViewDataSource

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = profileViewModel(rawValue: indexPath.row)
        
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
         return cell
    }
   
}

//MARK: - UItableViewDelegate


extension ProfileController {
    //section에 공간이 생긴다. 위에 그라데이션이랑 테이블 뷰 그룹 사이에 공간
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = profileViewModel(rawValue: indexPath.row) else { return }
        switch viewModel {
        case .accountInfo:
            print("show info page")
        case .settings:
            print("show setting page")
        }
    }
}

//MARK: - ProfileHeaderDelegate
extension ProfileController: profileHeaderDelegate {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    
}
//MARK: - ProfileFooterDelegate

extension ProfileController:
ProfileFooterDelegate {
    func handleLogOut() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                //protocol을 써도 기존화면을 dismiss해야 하기 때문에.. conversation controller에서 dismiss 됬고 그다음에 이거.
                self.delegate?.handleLogOut()
            }
           
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}



