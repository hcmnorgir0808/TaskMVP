//
//  WebViewPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/09.
//

import Foundation

protocol WebViewPresenterInput {
    func viewDidloaded()
}

final class WebViewPresenter: WebViewPresenterInput {
    private var githubModel: GithubModel
    private weak var output: WebViewPresenterOutput?
    
    init(model: GithubModel, output: WebViewPresenterOutput) {
        self.githubModel = model
        self.output = output
    }
    
    func viewDidloaded() {
        guard
            let url = URL(string: githubModel.urlStr) else {
            return
        }
        
        self.output?.load(url: url)
        
    }
}
