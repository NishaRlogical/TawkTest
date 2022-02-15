//
//  LoadingIndicatorTableViewCell.swift
//  TawkDevTest
//
//  Created by rlogical-dev-59 on 15/02/22.
//

import UIKit

class LoadingIndicatorTableViewCell: UITableViewCell {
    fileprivate lazy var indicator = UIActivityIndicatorView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Initialization tableviewcell
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)

        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func startAnimating() {
        indicator.startAnimating()
    }
}
