//
//  UsersViewController.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 14/02/22.
//

import UIKit

class UsersViewController: UIViewController {
    // users view model
    fileprivate var viewModel: UsersViewModel!
   
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var objSearchBar: UISearchBar!
    @IBOutlet weak var nslcNoInternet: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Users"
        viewModel = UsersViewModel(controller: self)
        objSearchBar.delegate = viewModel
       
        // setup tableview
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.register(LoadingIndicatorTableViewCell.self, forCellReuseIdentifier: "LoadingIndicatorTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0

        // load data
        viewModel.loadData()

        // handler for reloadData table view evnets
        viewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                if self == nil {
                    return
                }
                self?.tableView.reloadData()
            }
        }

        viewModel.onSelectUser = { [weak self] user in
            if self == nil {
                return
            }
            let controller = self?.storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
            controller.setUser(user: user)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadData()
    }
    
    
}
