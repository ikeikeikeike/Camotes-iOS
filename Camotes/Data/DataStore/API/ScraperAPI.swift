//
//  ScraperAPI.swift
//  ScraperInjector
//
//  Created by Tatsuo Ikeda on 2018/03/16.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import Moya

enum ScraperAPI {
    case info(url: String)
    case stream(url: String)
}

// MARK: - TargetType Protocol Implementation
extension ScraperAPI: TargetType, AccessTokenAuthorizable {
    
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8000")!
    }
    
    var path: String {
        switch self {
        case .info(let url):
            return "/api/info/\(url.data(using: .utf8)?.base64EncodedString() ?? "")"
        case .stream(let url):
            return "/api/stream/\(url.data(using: .utf8)?.base64EncodedString() ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        default:
            return .none
        }
    }
    
    var task: Task {
        let params = [String: Any]()
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        let resource: String? = String(describing: self)
        let path = Bundle.main.path(forResource: resource, ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
    
}
