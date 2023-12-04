//
//  StationList.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/30.
//

import Foundation
import Alamofire


struct StationListRequest: APIRequest {
    var method = HTTPMethod.get
    var path = ApiURL.stationList
    var parameters = [String: Any]()
    
    init() {
    
    }

}

//MARK: StationListRespModel
struct StationListRespModel: Codable {
    var stationList: [StationListItem]?     // 站點列表
}

struct StationListItem: Codable, Hashable, Identifiable {
    let id = UUID()
    
    enum CodingKeys: CodingKey {
        case sno
        case sna
        case tot
        case sbi
        case sarea
        case mday
        case lat
        case lng
        case ar
        case sareaen
        case snaen
        case aren
        case bemp
        case act
        case srcUpdateTime
        case updateTime
        case infoTime
        case infoDate
    }
    
    var sno: String?                    // 站點編號
    var sna: String?                    // 站點名稱
    var tot: Int?                       // 站點總停車格數
    var sbi: Int?                       // 目前車輛數
    var sarea: String?                  // 行政區
    var mday: String?                   // 微笑單車各場站來源資料更新時間
    var lat: Double?                    // 緯度
    var lng: Double?                    // 經度
    var ar: String?                     // 地址
    var sareaen: String?                // 英文行政區
    var snaen: String?                  // 英文站點名稱
    var aren: String?                   // 英文地址
    var bemp: Int?                      // 空位數量
    var act: String?                    // 站點目前是否禁用
    var srcUpdateTime: String?          // 微笑單車系統發布資料更新的時間
    var updateTime: String?             // 北市府交通局數據平台經過處理後將資料存入DB的時間
    var infoTime: String?               // 微笑單車各場站來源資料更新時間
    var infoDate: String?               // 微笑單車各場站來源資料更新時間
}




