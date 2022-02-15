//
//  UserDetailsViewModel.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import Foundation
import UIKit

class UserDetailsViewModel {
    fileprivate var user: User

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

    fileprivate var controller: UserDetailsViewController

    init(controller: UserDetailsViewController, user: User) {
        // set queue for background task execution
        queue.qualityOfService = .background
        self.controller = controller
        self.user = user
    }

    func fetchData() {
        guard let login = user.login else {
            return
        }
        fetchUserDetails(login: login)
    }

    func fetchUserDetails(login: String) {
        isLoading = true

        // cancle all previous enqued operations
        queue.cancelAllOperations()

        // add new operation
        queue.addOperation {
            // check internet connectivity
            if InternetConnectivityMoniter.instance.isInternetConnected {
                GithubAPI.details(login: login).request(type: User.self) { [weak self] result in
                    switch result {
                    case let .success(details):
                        self?.user = details
                        self?.setData()
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    func setData() {
       
        
        DispatchQueue.main.async {
            self.controller.lblFollwerCount.text = "followers:\(self.user.followers)"
            self.controller.lblFollowingCount.text = "following:\(self.user.following)"
            if let avatarURL = self.user.avatarURL, let remoteURL = URL(string: avatarURL) {
                self.controller.imgUser?.setImage(from: remoteURL)
            }
            self.controller.lblName.text = "Name: \(self.user.name ?? "")"
            self.controller.lblCompany.text = "Company: \(self.user.company ?? "")"
            self.controller.lblBlog.text = "Blog: \(self.user.blog ?? "")"
            self.controller.txtNotes.text = self.user.notes ?? ""
        }
        
        if let user = Store.instance.fetchUserData(id: Int(self.user.id)) {
            DispatchQueue.main.async {
                self.controller.txtNotes.text = user.notes ?? ""
            }
        }

    }

    func saveNotes(text: String) {
        user.notes = text
        Store.instance.save()
    
        
    }
}
