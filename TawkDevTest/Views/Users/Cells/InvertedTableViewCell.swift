//
//  InvertedTableViewCell.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import UIKit

class InvertedTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvtar: UIImageView!
    @IBOutlet weak var lblUserDetail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let width = imgAvtar?.frame.width {
            imgAvtar?.layer.cornerRadius = width / 2
            imgAvtar?.layer.masksToBounds = true
        }
    }
}

extension InvertedTableViewCell: UserCellConfirmable {
    func setUser(user: User) {
        lblUserName?.text = user.login
        lblUserDetail?.text = user.type
        if let avatarURL = user.avatarURL, let remoteURL = URL(string: avatarURL) {
            imgAvtar?.setImage(from: remoteURL)
            imgAvtar?.image = imgAvtar?.image?.invertedImage()
        }
    }
}
