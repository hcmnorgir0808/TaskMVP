//
//  GithubSearchPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/06.
//

import Foundation

protocol GithubSearchPresenterInput {
    var githubModels: [GithubModel] { get }
    func tapSearchButton(searchWord: String?)
}

final class GithubSearchPresenter: GithubSearchPresenterInput {
    
    var githubModels = [GithubModel]()
    
    private weak var output: GithubSearchPresenterOutput?
    
    init(output: GithubSearchPresenterOutput) {
        self.output = output
    }
    
    func tapSearchButton(searchWord: String?) {
        guard let searchWord = searchWord, !searchWord.isEmpty else {
            self.githubModels = []
            self.output?.updateData()
            return
        }
        
        GithubAPI.shared.get(searchWord: searchWord) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                self.githubModels = []
            case .success(let items):
                self.githubModels = items
            }
            
            self.output?.updateData()
        }
    }
}
