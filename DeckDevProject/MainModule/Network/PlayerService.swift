//
//  PlayersNetworkManager.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 30.04.2023.
//

import Foundation
import RxSwift
import Moya

final class PlayerService {
    
    static let shared = PlayerService()
    private let provider = MoyaProvider<NetworkService>()
    
    func getPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
        provider.request(.getPlayers) { result in
            switch result {
            case let .success(response):
                do {
                    let players = try JSONDecoder().decode([Player].self, from: response.data)
                    completion(.success(players))
                    
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    
}
