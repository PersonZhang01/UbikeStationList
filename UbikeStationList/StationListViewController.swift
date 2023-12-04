//
//  StationListViewController.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/11/29.
//

import UIKit
import Combine

class StationListViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var tableHeadView: UIView!
    @IBOutlet weak var tableBodyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchView: DropDownMenuView!

    // pipeline(管道)的開頭
    private let idle = PassthroughSubject<Void, Never>()
    private let getStationList = PassthroughSubject<Void, Never>()
    
    // ViewModel
    public let viewModel: StationListViewModel = StationListViewModel(
        stationListUseCase: StationListUseCase())
    
    // 取消pipeline(管道)的引用
    private var anycancellableSet: Set<AnyCancellable> = []
    
    // 控制項、其他常數及變數
    private lazy var dataSource = createDataSource()
    let refreshControl = UIRefreshControl()
    
    //MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStationList.send()
    }
    
    func configureUI() {
        configureTableView()
        
        tableHeadView.setView(withCornerRadius: CornerRadiusSize.large)
        tableBodyView.setView(withCornerRadius: CornerRadiusSize.large,
                          borderColor: nil,
                          borderWidth: 0,
                          maskedCorners: [.layerMaxXMaxYCorner,.layerMinXMaxYCorner])
        tableView.setView(withCornerRadius: CornerRadiusSize.large,
                          borderColor: nil,
                          borderWidth: 0,
                          maskedCorners: [.layerMaxXMaxYCorner,.layerMinXMaxYCorner])
        
        searchView.updateMenuUI(withListCount: 2, selection: nil, placeHolder: Constant.search)
        searchView.tag = 0
        searchView.delegate = self
    }
    
    //MARK: UI change
    private func bind(to viewModel: StationListViewModel) {
        anycancellableSet.forEach{ $0.cancel() }
        anycancellableSet.removeAll()
        let input = StationListViewModelInput(
            idle: idle,
            stationList: getStationList)
        let output = viewModel.transform(input: input)
        
        output.sink(receiveValue: {[unowned self] state in
            render(state)
        }).store(in: &anycancellableSet)
    }
    
    // 輸出的狀態
    private func render(_ state: StationListViewModelState) {
        switch state {
        case .idle: return
        case .stationListSuccess(let resp):
            stationListSuccess(resp: resp)
        case .stationListError(let resp):
            stationListError(error: resp)
        }
        idle.send()
    }
    
    func stationListSuccess(resp: [StationListItem]?) {
        debugPrint("StationListViewModelState:stationListSuccess.")
        resp?.getJsonString()
        viewModel.updateStationList(withList: resp ?? [])
        update(withList: viewModel.stationList, animate: false)
    }
    
    func stationListError(error: NetworkError?) {
        debugPrint("StationListViewModelState:stationListError.\(error.debugDescription)")
    }

    //MARK: TableView
    func configureTableView() {
        // 註冊Cell
        tableView.registerNib(cellClass: StationListTableViewCell.self)

        // 設置delegate 跟 source
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60.0
    }
    
    @objc
    func reloadTableView() {
        searchView.updateMenuUI(withListCount: 2, selection: nil, placeHolder: Constant.search)
        getStationList.send()
    }
    
    private enum Section: CaseIterable {
        case list
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, StationListItem> {
        return UITableViewDiffableDataSource(tableView: tableView) {[unowned self] tableView, indexPath, cellData in
            let cell = tableView.dequeueReusableCell(withClass: StationListTableViewCell.self, forIndexPath: indexPath)
            cell.bindWithList(cellData: cellData, indexPath: indexPath)
            return cell
        }
    }
    
    func update(withList list: [StationListItem], animate: Bool = true) {
        DispatchQueue.main.async { [unowned self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, StationListItem>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(list, toSection: .list)
            dataSource.apply(snapshot, animatingDifferences: animate)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

}

// MARK: UITableViewDelegate
extension StationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

//MARK: DropDownMenuViewDelegate
extension StationListViewController: DropDownMenuViewDelegate {
    func selectButtonPressed(withTag tag: Int) {
        debugPrint("selectButtonPressed tag: \(tag)")
        var list:[MenuModel] = []
        let topSpace = searchView.frame.minY
        var itemFrame:CGRect = CGRect(x: searchView.frame.origin.x,
                                      y: topSpace + searchView.frame.origin.y,
                                  width: searchView.frame.width,
                                  height: searchView.frame.height)
        
        list = viewModel.areaList.map({MenuModel(name: $0, identity: $0)})
        
        let alert = MenuViewController()
        alert.setAlert(itemFrame: itemFrame, selectList: list, tag: tag)
        alert.delegate = self
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        present(alert, animated: true)
    }
}

// MARK: MenuViewControllerDelegate
extension StationListViewController: MenuViewControllerDelegate {
    func selectItem(with item: MenuModel, tag: Int) {
        self.viewModel.searchArea(withKey: item.identity)
        searchView.updateMenuUI(withListCount: self.viewModel.searchArea.count, selection: item.name)
        update(withList: viewModel.stationList, animate: false)
    }
}


