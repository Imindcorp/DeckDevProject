//
//  MainViewModel.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 30.04.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelInputs {
    func fetchPlayers(completion: @escaping (Error?) -> Void)
    func fetchUpdatedPlayers()
}

protocol MainViewModelOutputs {
    var players: PublishSubject<[Player]> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelInputs, MainViewModelOutputs, MainViewModelType {
    var inputs: MainViewModelInputs {
        return self
    }
    var outputs: MainViewModelOutputs {
        return self
    }
    
    // По хорошему вероятно лучше было биндить с вьюконтроллером через драйверы, он он иммутабл и поэтому никак не хотел меняться/добавлять эвенты. До конца не успел разобраться как это реализовать, поэтому пока сделал так. Понимаю, что при таком подходе существует риск появления непредвиденных событий в аутпуте.
    var players = PublishSubject<[Player]>()
    private let playerService = PlayerService.shared
    
    func fetchPlayers(completion: @escaping (Error?) -> Void) {
        playerService.getPlayers() { [weak self] result in
            switch result {
            case let .success(players):
                self?.players.onNext(players)
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
    
    //метод ниже служит эмуляцией обновленного массива данных из бека. Удалить после добавления нормального бека, не забыть подправить в MainViewController метод bindNotifications()
    func fetchUpdatedPlayers() {
        let players = [Player(name: "Новый игрок 1"),
                       Player(name: "Новый игрок 2"),
                       Player(name: "Новый игрок 3")]
        self.players.onNext(players)
    }
}


