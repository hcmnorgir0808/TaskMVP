//
//  MVCTableViewCell.swift
//  TaskMVP
//
//  Created by sakiyamaK on 2021/03/10.
//

import UIKit

/*
 MVCと基本変わらない
 */
final class MVPTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var urlLabel: UILabel!
    
    func configure(githubModel: GithubModel) {
        self.titleLabel.text = githubModel.fullName
        self.urlLabel.text = githubModel.urlStr
    }
}
