//
//  RepositoryListViewModel.swift
//  RepoSearcher
//
//  Created by Arthur Myronenko on 6/29/17.
//  Copyright © 2017 UPTech Team. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {

    // MARK: - Inputs

    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: BehaviorSubject<String>

    /// Call to show language list screen.
    let chooseLanguage: PublishSubject<Void>

    /// Call to open repository page.
    let selectRepository: PublishSubject<RepositoryViewModel>

    /// Call to reload repositories.
    let reload: PublishSubject<Void>

    // MARK: - Outputs

    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>

    /// Emits a formatted title for a navigation item.
    let title: Observable<String>

    /// Emits an error messages to be shown.
    let alertMessage: Observable<String>

    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>

    /// Emits when we should show language list.
    let showLanguageList: Observable<Void>

    init(initialLanguage: String, githubService: GithubService = GithubService()) {

        self.reload = PublishSubject<Void>()

        self.setCurrentLanguage = BehaviorSubject<String>(value: initialLanguage)

        self.title = self.setCurrentLanguage.asObservable()
            .map { "\($0)" }

        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()

        self.repositories = Observable.combineLatest( self.reload, self.setCurrentLanguage) { _, language in
            return language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }

        self.selectRepository = PublishSubject<RepositoryViewModel>()
        self.showRepository = self.selectRepository.asObservable()
            .map { $0.url }

        self.chooseLanguage = PublishSubject<Void>()
        self.showLanguageList = self.chooseLanguage.asObservable()
    }
}
