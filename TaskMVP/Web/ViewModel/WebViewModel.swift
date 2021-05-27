//
//  WebViewModel.swift
//  
//
//  Created by 岩本康孝 on 2021/05/25.
//

import Foundation

protocol WebViewModelOutput {
    var model: GithubModel { get }
}

final class WebViewModel: WebViewModelOutput {
    
    private(set) var model: GithubModel
    
    init(model: GithubModel) {
        self.model = model
    }
}
