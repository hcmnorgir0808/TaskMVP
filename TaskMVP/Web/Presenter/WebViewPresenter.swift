//
//  WebViewPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/09.
//

import Foundation

protocol WebViewPresenterInput {
    var githubModel: GithubModel { get }
}

final class WebViewPresenter: WebViewPresenterInput {
    
    var githubModel: GithubModel
    
    init(model: GithubModel) {
        self.githubModel = model
    }
}
