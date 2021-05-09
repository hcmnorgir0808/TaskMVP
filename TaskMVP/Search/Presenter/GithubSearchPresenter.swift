//
//  GithubSearchPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/06.
//

import Foundation

protocol GithubSearchPresenterInput {
    var items: [GithubModel] { get }
    func tapSearchButton(searchWord: String?)
}

final class GithubSearchPresenter: GithubSearchPresenterInput {
    
    var items = [GithubModel]()
    
    private weak var output: GithubSearchPresenterOutput?
    
    init(output: GithubSearchPresenterOutput) {
        self.output = output
    }
    
    func tapSearchButton(searchWord: String?) {
        guard let searchWord = searchWord, !searchWord.isEmpty else {
            self.items = []
            self.output?.updateData()
            return
        }
        
        GithubAPI.shared.get(searchWord: searchWord) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                self.items = []
            case .success(let items):
                self.items = items
            }
            
            self.output?.updateData()
        }
    }
}
