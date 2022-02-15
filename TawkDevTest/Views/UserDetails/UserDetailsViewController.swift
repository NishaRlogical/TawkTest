//
//  UserDetailsViewController.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblFollwerCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    
    fileprivate var viewModel: UserDetailsViewModel!
    fileprivate var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserDetailsViewModel(controller: self, user: user)
        title = user.login
        viewModel.fetchData()
        setUpUI()
    }
    
    func setUpUI(){
        self.txtNotes.layer.cornerRadius = 5
        self.txtNotes.layer.masksToBounds = true
        self.txtNotes.layer.borderColor = UIColor.lightGray.cgColor
        self.txtNotes.layer.borderWidth = 1.5
    }

    func setUser(user: User) {
        self.user = user
    }
    
    //MARK:- Save action
    @IBAction func btnSaveTap(_ sender: Any) {
        if !txtNotes.text.isEmpty {
            viewModel.saveNotes(text: txtNotes.text)
        }
        CustomAlertController.showtitleMessage(title: "", message: "Note saved!")
        
    }
    
}
