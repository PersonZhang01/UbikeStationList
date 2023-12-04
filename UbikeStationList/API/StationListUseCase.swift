//
//  StationListUseCase.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/30.
//

import Foundation
import Combine
import Alamofire

// 使用API的protocol，降低耦合度
protocol StationListUseCaseType {
    func stationList() -> AnyPublisher<DataResponse<[StationListItem],NetworkError>, Never>
}

// 實作API的Class
class StationListUseCase: StationListUseCaseType {
    func stationList() -> AnyPublisher<Alamofire.DataResponse<[StationListItem], NetworkError>, Never> {
        return APIManager.shared.fetchResponse(apiReq:StationListRequest())

    }
}


