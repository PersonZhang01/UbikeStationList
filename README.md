# UbikeStationList
iOS Swift Project
使用 Combine framework 實作 MVVM 架構的程式 
取得台北市所有UBike站點

[站點列表](https://raw.github.com/PersonZhang01/UbikeStationList/master/Screenshot/StationList.png)
[搜尋區域](https://raw.github.com/PersonZhang01/UbikeStationList/master/Assets/SearchArea.png)

1. 區域請顯示 API 中 “sarea” 欄位資料
2. 站點名稱請顯示 API 中 “sna” 欄位資料
3. 搜尋站點請搜尋特定區域的資料，例如搜尋 “松山區”，顯示在松山區的所有站點
==============
*   [Request](#request)
*   [Response](#response)

<h2 id="request">Request</h2>

*   method: Get
*   url: https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json

<h2 id="response">Response</h2>

```json
[
    {
        "sno": String, //站點編號
        "sna": String, //站點名稱
        "tot": Int, //站點總停車格數
        "sbi": Int, //目前車輛數
        "sarea": String, //行政區 ex.大安區、中山區
        "mday": String, //微笑單車各場站來源資料更新時間
        "lat": Double, //緯度
        "lng": Double, //經度
        "ar": String, //地址
        "sareaen": String, //英文行政區 ex.大安區、中山區
        "snaen": String, //英文站點名稱
        "aren": String, //英文地址
        "bemp": Int, //空位數量
        "act": String, //站點目前是否禁用 ex."0"禁用中, "1"啟用中
        "srcUpdateTime": String, //微笑單車系統發布資料更新的時間
        "updateTime": String, //北市府交通局數據平台經過處理後將資料存入DB的時間
        "infoTime": String, //微笑單車各場站來源資料更新時間
        "infoDate": String //微笑單車各場站來源資料更新時間
    }
]
```