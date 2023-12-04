//
//  APIComposition.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/30.
//

import Foundation
import Alamofire

protocol APIRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String : Any] { get }
}

extension APIRequest {
    
    func getHeader() -> HTTPHeaders {
        var result: [String: String] = [:]
        return HTTPHeaders(result)
    }
    
    func getUrlString() -> String {
        return "\(APIManager.host)\(path)"
    }
}

struct ApiResp<T: Codable>: Codable {
    var success: Bool?
    var msg: String?
    var value: T?
}

struct ApiURL {
    
    static let stationList = "/dotapp/youbike/v2/youbike_immediate.json"            // 取得站點列表
    
}

