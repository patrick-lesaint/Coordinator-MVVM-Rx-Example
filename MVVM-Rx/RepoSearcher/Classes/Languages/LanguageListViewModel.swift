//
//  LanguageListViewModel.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 7/12/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import RxSwift

class LanguageListViewModel {

    // MARK: - Inputs

    let selectLanguage: PublishSubject<String>
    let cancel: PublishSubject<Void>

    // MARK: - Outputs

    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>

    init(githubService: GithubService = GithubService()) {
        self.languages = githubService.getLanguageList()

        self.selectLanguage = PublishSubject<String>()
        self.didSelectLanguage = selectLanguage.asObservable()

        self.cancel = PublishSubject<Void>()
        self.didCancel = cancel.asObservable()
    }
}
