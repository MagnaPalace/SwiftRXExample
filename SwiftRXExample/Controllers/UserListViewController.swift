//
//  UserListViewController.swift
//  SwiftRXExample
//
//  Created by Takeshi Kayahashi on 2022/07/10.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxBinding

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private typealias Input = UserListViewModelInput
    private typealias Output = UserListViewModelOutput
    
    private var input: Input!
    private var output: Output!
    
    let items = PublishSubject<[User]>()
    
//    private let disposeBag = DisposeBag()
    var viewModel = UserListViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.input = viewModel
        self.output = viewModel
        
        super.init(coder:coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        self.viewModel.users
            .observe(on: MainScheduler.instance)
            .bind(to: self.tableView.rx.items(cellIdentifier: "UserListTableViewCell", cellType: UserListTableViewCell.self)) { row, user, cell in
            cell.initialize(model: .init(userNo: user.userId, name: user.name, comment: user.comment))
                }
            .disposed(by: rx.disposeBag)
        
        // fetch
        self.viewModel.fetchUsers()
        
        // Bind inputs
        
        // Bind outputs
        rx.disposeBag ~
            output.users ~> items ~
            output.title ~> rx.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

}

extension UserListViewController: UITableViewDelegate {
    
}
