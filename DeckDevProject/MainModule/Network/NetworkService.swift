//
//  NetworkService.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 28.04.2023.
//

import Moya

enum NetworkService {
    case getPlayers
}

extension NetworkService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .getPlayers:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPlayers:
            return .get
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}




