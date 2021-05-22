//
//  GithubSearchPresenter.swift
//  TaskMVP
//
//  Created by 岩本康孝 on 2021/05/06.
//

import Foundation

protocol GithubSearchPresenterInput {
    var numberOfItems: Int { get }
    func item(at: Int) -> GithubModel
    func tapSearchButton(searchWord: String?)
    func didSelect(at index: Int)
}

final class GithubSearchPresenter {
    
    private var githubModels = [GithubModel]()
    
    private weak var output: GithubSearchPresenterOutput?
    private var api: GithubAPIProtocol
    
    init(output: GithubSearchPresenterOutput, api: GithubAPIProtocol) {
        self.output = output
        self.api = api
    }
}

extension GithubSearchPresenter: GithubSearchPresenterInput {
    var numberOfItems: Int { githubModels.count }
    
    func item(at index: Int) -> GithubModel { githubModels[index] }
    
    func tapSearchButton(searchWord: String?) {
        guard let searchWord = searchWord, !searchWord.isEmpty else {
            self.githubModels = []
            self.output?.updateData()
            return
        }
        
        self.output?.update(loading: true)
        
        api.get(searchWord: searchWord) { [weak self] result in
            self?.output?.update(loading: false)
            switch result {
            case .failure(let error):
                self?.output?.get(error: error)
                self?.githubModels = []
            case .success(let items):
                self?.githubModels = items
            }
            self?.output?.updateData()
        }
    }
    
    func didSelect(at index: Int) {
        output?.showWeb(githubModel: githubModels[index])
    }
}
