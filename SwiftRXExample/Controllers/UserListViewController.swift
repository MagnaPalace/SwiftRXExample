//
//  UserListViewController.swift
//  SwiftRXExample
//
//  Created by Takeshi Kayahashi on 2022/07/10.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "SwiftRxExample"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

}

extension UserListViewController: UITableViewDelegate {
    
}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
