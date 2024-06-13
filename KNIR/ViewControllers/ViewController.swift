//
//  ViewController.swift
//  KNIR
//
//  Created by kirill on 14.05.2024.
//

import UIKit

class ViewController: UIViewController, UISheetPresentationControllerDelegate {
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var pathTextView: UITextView!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var floorMenuTableVIew: UITableView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // Select Campus vars
    @IBOutlet weak var selectCampusButton: UIButton!
    private var validCampuses = ["Корпус А", "Корпус Б", "Корпус Г"]
    private var selectedCampus = ""
    
    // Path vars
    private var startName: String = ""
    private var endName: String = ""
    var map: Map = Map(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main View did  load")
        NotificationCenter.default.addObserver(self, selector: #selector(readyToBuildPathNotification(_:)), name: .didSetPoints, object: nil)
        mainView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Main View did apear")
        showPathMenu()
    }

    private func mainView() {
        view.backgroundColor = .mainBackground
        pathTextView.text = nil
        pathTextView.backgroundColor = .mainBackground
        pathTextView.textColor = .white
        floorLabel.textColor = .white
        pathTextView.textAlignment = .center
        totalTimeLabel.text = nil
        totalTimeLabel.backgroundColor = .mainBackground
        totalTimeLabel.textColor = .white
        totalTimeLabel.textAlignment = .center
        selectCampusButton.setTitle("Корпус Б", for: .normal)
        selectCampusButton.tintColor = .misisBlue
//        selectCampusButton.isEnabled = false
//        selectCampusButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
//        view.addSubview(selectCampusButton)
        
        map.initializeGraph()
        print(map.currentFloor)
    
        floorMenuTableVIew.delegate = self
        floorMenuTableVIew.dataSource = self
        
        floorMenuTableVIew.register(UITableViewCell.self, forCellReuseIdentifier: "FloorCell")
        
        floorMenuTableVIew.separatorStyle = .none
        floorMenuTableVIew.backgroundColor = UIColor.clear
        floorMenuTableVIew.isScrollEnabled = (map.floorsAmount > 6)
    }
    
    private func showPathMenu() {
        print("Showing path menu")
        let pathMenuVC = PathMenuViewController()
        pathMenuVC.validPoints = self.map.availablePoints
        pathMenuVC.modalPresentationStyle = .pageSheet
        pathMenuVC.isModalInPresentation = true
        if let sheet = pathMenuVC.sheetPresentationController {
            sheet.detents = [.small]
            sheet.largestUndimmedDetentIdentifier = .small
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }

        present(pathMenuVC, animated: true, completion: nil)
    }
    
    @objc private func readyToBuildPathNotification(_ notification: Notification) {
        if let pointsInfo = notification.userInfo,
           pointsInfo["startPoint"] as! String != "",
           pointsInfo["endPoint"] as! String != "" {
            print("Building path")
            startName = pointsInfo["startPoint"] as! String
            endName = pointsInfo["endPoint"] as! String
            map.currentFloor = map.wholeGraph.nodeMap[startName]!.floor
            selectRow(floor: map.currentFloor)
            pathTextView.text = nil

            map.findPath(startName, endName)
            showPath()
//            showPath(path: map.leveledPath[map.currentFloor]!, floor: map.currentFloor)
            print("Total time: \(String(describing: map.path.last!.distance)) м")
            totalTimeLabel.text = "\(String(describing: map.path.last!.distance)) м"
        } else {
            print("Clearing path")
            pathTextView.text = nil
            totalTimeLabel.text = nil
        }
            
    }
    
//    @objc private func openSearch() {
//        var searchSwiftUIView = SearchSwiftUIView(searchSelectedCampus: selectedCampus, validCampuses: validCampuses)
//
//        searchSwiftUIView.searchSelectedCampus = selectedCampus
//        searchSwiftUIView.onSelectCampus = { [weak self] selectedCampus in
//            self?.selectedCampus = selectedCampus
//            print(self!.selectedCampus)
//            self?.selectCampusButton.setTitle(self?.selectedCampus, for: .normal)
//            self?.dismiss(animated: true, completion: nil)
//        }
//
//        let controller = UIHostingController(rootView: searchSwiftUIView)
//        let sheetController = controller.sheetPresentationController
//        sheetController?.detents = [.medium(), .large()]
//        sheetController?.preferredCornerRadius = 16
//        sheetController?.prefersGrabberVisible = true
//        sheetController?.delegate = self
//        present(controller, animated: true)
//    }


    
    private func selectRow(floor: Int) {
        let indexPath = IndexPath(row: floor - 1, section: 0)
        floorMenuTableVIew.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        floorMenuTableVIew.delegate?.tableView?(floorMenuTableVIew, didSelectRowAt: indexPath)
    }
}

// Path logic
extension ViewController {
    private func showPath() {
        var pathText: String = ""
        let path: [PathNode] = map.leveledPath[map.currentFloor]!
        if path.isEmpty || map.leveledPath[map.currentFloor]!.isEmpty {
            pathTextView.text = nil
            return
        }
        print("Floor: \(map.currentFloor)")
        var lastPoint: PathNode?
        for point in path {
            print("\(point.name)")
            if point.type != PathNode.types.stairs {
                if point.name != endName { pathText += "\(point.name) -> " }
                else { pathText += "\(point.name)" }
            }
            lastPoint = point
        }
        print(lastPoint!.name)
        for i in 0..<(map.path.count){
            if map.path[i].prev?.name == lastPoint!.name {
                if map.path[i].floor > lastPoint!.floor {
                    print("Поднимитесь по лестнице")
                    pathText += "\n\nПоднимитесь по лестнице"
                } else {
                    print("Спуститесь по лестнице")
                    pathText += "\n\nСпуститесь по лестнице"
                }
                break
            }
        }
        pathTextView.text = pathText
    }
}


// Floor Side Menu
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return map.floorsAmount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.indentationWidth = 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        cell.textLabel?.textColor = .white
        tableView.layer.borderWidth = 2
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor  = UIColor.misisBlue.cgColor
        
        if map.currentFloor == indexPath.row + 1 {
            cell.contentView.backgroundColor = .misisBlue
            cell.textLabel?.textColor = .white
            cell.layer.cornerRadius = 3
            cell.clipsToBounds = true
        } else {
            cell.contentView.backgroundColor = .lightBackground
            cell.textLabel?.textColor = .white
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        map.currentFloor = indexPath.row + 1
        tableView.reloadData()
        floorLabel.text = "Этаж \(map.currentFloor)"
        if map.isWithPath {
            showPath()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        true
    }
}

extension UISheetPresentationController.Detent {
    static let small = UISheetPresentationController.Detent.custom(identifier: .small) {
        context in { return 120 }()
    }
}

extension UISheetPresentationController.Detent.Identifier {
    static let small = UISheetPresentationController.Detent.Identifier("small")
}
