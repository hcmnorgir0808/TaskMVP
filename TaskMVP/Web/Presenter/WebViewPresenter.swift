//
//  WebViewPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/09.
//

import Foundation

protocol WebViewPresenterInput {
    var model: GithubModel { get }
}

final class WebViewPresenter: WebViewPresenterInput {
    
    var model: GithubModel
    
    init(model: GithubModel) {
        self.model = model
    }
}
