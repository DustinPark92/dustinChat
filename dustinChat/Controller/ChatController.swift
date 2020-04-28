//
//  ChatController.swift
//  dustinChat
//
//  Created by Dustin on 2020/04/27.
//  Copyright © 2020 Dustin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ChatCell"

class ChatController: UICollectionViewController {
    //MARK: - Properties
    
    private let user:User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var custominputView: CustomInputAccessroyView = {
        let iv = CustomInputAccessroyView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: - API
    
    func fetchMessage() {
        Service.fetchMessage(forUSer: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
            //새 메세지 생길때마다 제일 하단으로 내려가게 함.
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
    override var inputAccessoryView: UIView? {
        get { return custominputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - Helpers
    
    func configureUI () {
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        
        //채팅 창 올리면 키보드 아래로 내려감
        collectionView.keyboardDismissMode = .interactive
        
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }
}


extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
             return cell
    }
     
    
}


extension ChatController: UICollectionViewDelegateFlowLayout {
    
    //collectionview spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimateSizeCell = MessageCell(frame: frame)
        estimateSizeCell.message = messages[indexPath.row]
        estimateSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        
        //cell size 예측 해줌
        let estimatedSize = estimateSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
}


extension ChatController : CustomInputAccessroyViewDelegate {
    func inputView(_ inputView: CustomInputAccessroyView, wantsTosend message: String) {
        
        
        Service.uploadMessage(message, to: user) { (error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
        }
        inputView.clearMessageText()

    }
    
}
