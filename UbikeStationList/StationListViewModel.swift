//
//  StationListViewModel.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/30.
//

import Foundation
import Combine

// ViewModel pipeline輸入源頭
struct StationListViewModelInput {
    let idle: PassthroughSubject<Void, Never>
    let stationList: PassthroughSubject<Void, Never>
}

// ViewModel pipeline輸出終點
enum StationListViewModelState {
    case idle
    case stationListSuccess([StationListItem]?)
    case stationListError(NetworkError?)
}

extension StationListViewModelState: Equatable {
    static func == (lhs: StationListViewModelState, rhs: StationListViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.stationListSuccess, .stationListSuccess): return true
        case (.stationListError, .stationListError): return true
        default: return false
        }
    }
}

typealias StationListViewModelOutput = AnyPublisher<StationListViewModelState, Never>

// 轉換輸入成輸出的protocol
protocol StationListViewModelType {
    func transform(input: StationListViewModelInput) -> StationListViewModelOutput
}

// 實作轉換內容
class StationListViewModel: StationListViewModelType {
    private let stationListUseCase: StationListUseCaseType
    
    var stationList: [StationListItem] = []
    var stationAllList: [StationListItem] = []
    var areaList: [String] = []
    var searchArea: String = ""
    var selectIndexPath: IndexPath = IndexPath()
    
    init(stationListUseCase: StationListUseCaseType){
        self.stationListUseCase = stationListUseCase
    }
    
    func transform(input: StationListViewModelInput) -> StationListViewModelOutput {
        return Publishers.Merge(inputIdle(idle: input.idle),
                                 inputStationList(stationList: input.stationList))
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    private func inputIdle(idle: PassthroughSubject<Void, Never>) -> StationListViewModelOutput {
        let initialState: StationListViewModelOutput = .just(.idle)
        let idleState: StationListViewModelOutput = idle.map({ .idle }).eraseToAnyPublisher()
        return Publishers.Merge(initialState, idleState).eraseToAnyPublisher()
    }
    
    private func inputStationList(stationList: PassthroughSubject<Void, Never>) -> StationListViewModelOutput {
        let request: StationListViewModelOutput = stationList.flatMapLatest({[unowned self]
            query in
            stationListUseCase.stationList()
        })
            .map({ result -> StationListViewModelState in
                switch result {
                case _ where result.value != nil:
                    return .stationListSuccess(result.value)
                case _ where result.error != nil: return .stationListError(result.error)
                default: return .idle
                }
            }).eraseToAnyPublisher()
        return request
    }
    
}

extension StationListViewModel {
    func updateStationList(withList list: [StationListItem]?) {
        guard let list = list else { return }
        stationAllList = list
        stationList = list
        areaList = stationList.reduce(into: [String]()) { result, station in
            guard let sarea = station.sarea else { return }
            if !result.contains(sarea) {
                result.append(sarea)
            }
        }
    }
    
    func searchArea(withKey key: String?) {
        searchArea = key ?? ""
        stationList.removeAll()
        stationList = stationAllList.reduce(into: [StationListItem]()) { result, station in
            guard let sarea = station.sarea else { return }
            if sarea == searchArea {
                result.append(station)
            }
        }
    }

}



