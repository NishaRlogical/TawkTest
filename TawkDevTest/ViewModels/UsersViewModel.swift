//
//  UsersViewModel.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 14/02/22.
//

import Foundation
import UIKit

/// Users View Model
class UsersViewModel: NSObject {
    // Array of Users
    fileprivate var users: [User] = []
    fileprivate var copyOfUsers: [User] = []
    
    // loding state
    private var isLoading: Bool = false {
        didSet {
            onLoadingStateChange?(isLoading)
        }
    }
    
    // loding state event
    typealias LoadingEvent = (Bool) -> Void
    public var onLoadingStateChange: LoadingEvent?
    
    // operation queue
    fileprivate var queue = OperationQueue()
    
    
    fileprivate var controller: UsersViewController
    // Last loaded user id
    fileprivate var lastLoadedUserID: Int = 0
    
    // reload tableview event
    typealias ReloadEvent = () -> Void
    public var reloadData: ReloadEvent?
    
    // did Select User Evnet
    typealias SelectUserEvent = (User) -> Void
    public var onSelectUser: SelectUserEvent?
    
    init(controller: UsersViewController) {
        self.controller =  controller
        super.init()
        // set queue for background task execution
        queue.qualityOfService = .background
        
        // moniter internet connectivity
        InternetConnectivityMoniter.instance.onConnectivityStatusUpdate = { [weak self] isConnected in
            if self == nil {
                return
            }
            if isConnected {
                self?.loadData()
            }
        }
    }
    
    func loadData() {
        isLoading = true
        fetchUsers(since: lastLoadedUserID) { [weak self] result in
            switch result {
            case let .success(users):
                
                self?.users.append(contentsOf: users)
                self?.copyOfUsers.append(contentsOf: users)
                self?.isLoading = false
                
                self?.lastLoadedUserID = Int(users.last?.id ?? 0)
                // reload ui elements
                self?.reloadData?()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchBy(text: String) {
        let filteredUsers = users.filter {
            $0.login?.lowercased().contains(text.lowercased()) ?? false ||
            $0.notes?.lowercased().contains(text.lowercased()) ?? false
        }
        users = filteredUsers
        reloadData?()
    }
    
    func onCancledSearch() {
        users = copyOfUsers
        reloadData?()
    }
    
    /// Fetch all github users
    func fetchUsers(since: Int, complition: @escaping (Result<[User], Error>) -> Void) {
        // cancle all previous enqued operations
        queue.cancelAllOperations()
        
        // add new operation
        queue.addOperation {
            // check internet connectivity
            if InternetConnectivityMoniter.instance.isInternetConnected {
                DispatchQueue.main.async {
                    self.controller.nslcNoInternet.constant = 0
                }
                GithubAPI.users(since: since).request(type: [User].self) { [weak self] result in
                    if self == nil {
                        return
                    }
                    switch result {
                    case let .success(users):
                        // on sucessfully retriving users store all users into database
                        // persist data to database
                        Store.instance.save()
                        complition(.success(users))
                    case let .failure(error):
                        complition(.failure(error))
                    }
                }
            } else {
                // load data from database
                DispatchQueue.main.async {
                    self.controller.nslcNoInternet.constant = 35
                }
                
                let users = Store.instance.fetchUsers()
                complition(.success(users))
            }
        }
    }
}

extension UsersViewModel: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 2
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return users.count
        } else if section == 1 {
            // section no 1 will be used to show loding indicator cell
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if (indexPath.row + 1) % 4 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvertedTableViewCell", for: indexPath) as! InvertedTableViewCell
                cell.setUser(user: users[indexPath.row])
                return cell
            } else if Store.instance.userHasNotes(id: Int(users[indexPath.row].id)) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell") as! NoteTableViewCell
                cell.setUser(user: users[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NormalUserTableViewCell") as! NormalUserTableViewCell
                cell.setUser(user: users[indexPath.row])
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingIndicatorTableViewCell", for: indexPath) as! LoadingIndicatorTableViewCell
            return cell
        }
    }
}

extension UsersViewModel: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4, !isLoading {
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        onSelectUser?(users[indexPath.row])
    }
}

extension UsersViewModel : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            onCancledSearch()
        } else {
            searchBy(text: searchText)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onCancledSearch()
    }
    
}
