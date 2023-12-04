//
//  MenuViewController.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import UIKit
protocol MenuViewControllerDelegate: AnyObject {
    func selectItem(with item: MenuModel, tag: Int)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    
    weak var delegate: MenuViewControllerDelegate?
    
    // 點選物件位置
    private var selectFrame: CGRect = CGRect()
    private var list: [MenuModel] = []
    private let tableView: UITableView = UITableView()
    let defaultHeight: CGFloat = 44.0
    let tableViewBottomPadding: CGFloat = 15.0
    let tableViewTopPadding: CGFloat = 5.0
    let listMaxCount: Int = 5
    var bottomPaddingFix: CGFloat = 0.0
    private var tag: Int = 0
    private lazy var dataSource = createDataSource()
    
    //MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        update(with: list,animate: false)
    }

    deinit {
        print("MenuViewController Deinit!")
    }
    
    //MARK: configure UI
    func configureUI() {
        addTapToDismiss()
    }
    
    func addTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        backGroundView.addGestureRecognizer(tap)
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    func setAlert(itemFrame: CGRect,
                  selectList: [MenuModel],tag: Int = 0) {
        selectFrame = itemFrame
        list = selectList
        self.tag = tag
    }
    
    //MARK: TableView
    func setTableViewFrame() {
        tableView.frame = getFrame()
        debugPrint("tableView:\(tableView.frame)")
    }
    
    func getFrame() -> CGRect {
        return CGRect(x: selectFrame.minX,
                      y: selectFrame.maxY + tableViewTopPadding,
                      width: selectFrame.width,
                      height: min((CGFloat(list.count) * defaultHeight), (view.frame.maxY - selectFrame.maxY - tableViewBottomPadding - bottomPadding - bottomPaddingFix)))
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        // 註冊Cell
        tableView.registerNib(cellClass: MenuTableViewCell.self)
        setTableViewFrame()
        // 設置delegate 跟 source
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    enum Section: CaseIterable {
        case names
    }
    
    func createDataSource() -> UITableViewDiffableDataSource<Section, MenuModel> {
        return UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, cellData in
            let cell = tableView.dequeueReusableCell(withClass: MenuTableViewCell.self, forIndexPath: indexPath)
            cell.bind(to: cellData)
            return cell
        }
    }
    
    func update(with list: [MenuModel], animate: Bool = true) {
        DispatchQueue.main.async {[unowned self] in
            var snapshot = NSDiffableDataSourceSnapshot<Section, MenuModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(list, toSection: .names)
            dataSource.apply(snapshot, animatingDifferences: animate)
            let scrollEnable = (CGFloat(list.count) * defaultHeight) > (view.frame.maxY - selectFrame.maxY - tableViewBottomPadding - bottomPadding - bottomPaddingFix)
            tableView.isScrollEnabled = scrollEnable
            tableView.frame = getFrame()
        }
    }
    
    //MARK: set Alert Data
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("indexPath:\(indexPath)")
        dismiss(animated: true) {[unowned self] in
            delegate?.selectItem(with: list[indexPath.row],tag: self.tag)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defaultHeight
    }
}


struct MenuModel: Identifiable, Hashable {
    let id = UUID()
    var name: String?
    var identity: String?
    var marked: Bool = false
}

