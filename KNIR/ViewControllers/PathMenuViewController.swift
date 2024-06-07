import UIKit

class PathMenuViewController: UIViewController, UISheetPresentationControllerDelegate {
    private let startButton = UIButton(type: .system)
    private let endButton = UIButton(type: .system)
    private let startTextField = UITextField()
    private let endTextField = UITextField()
    private let tableView = UITableView()
    var validPoints: [String] = []
    private var filteredPoints: [String] = []
    private var isEditingStart = false
    
    private var defaultStartTitle = "Откуда"
    private var defaultEndTitle = "Куда"
    var startPointValue: String? {
        didSet {
            checkAndPostNitification()
        }
    }
    var endPointValue: String? {
        didSet {
            checkAndPostNitification()
        }
    }
    private func checkAndPostNitification() {
        if let _ = startPointValue, let _ =  endPointValue {
            NotificationCenter.default.post(name: .didSetPoints, object: nil, userInfo: ["startPoint": startPointValue!, "endPoint": endPointValue!])
        } else {
            NotificationCenter.default.post(name: .didSetPoints, object: nil, userInfo: ["startPoint": "", "endPoint": ""])
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredPoints = validPoints.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        setupView()
//        validPoints = ViewController.map.availablePoints
        
        if let sheetPresentationController = presentationController as? UISheetPresentationController {
            sheetPresentationController.delegate = self
        }
    }
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard let selectedDetent = sheetPresentationController.selectedDetentIdentifier else {
            return
        }
        print("detent changed")
        switch selectedDetent {
        case .large:
            toggleEditingMode(isEditing: true)
            print("large")
        default:
            toggleEditingMode(isEditing: false)
            print("small")
        }

    }

    private func setupView() {
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        configureButton(startButton, title: defaultStartTitle)
        configureButton(endButton, title: defaultEndTitle)
//        startButton.backgroundColor =  .white
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)

        configureTextField(startTextField, placeholder: defaultStartTitle)
        configureTextField(endTextField, placeholder: defaultEndTitle)
        startTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        endTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        startTextField.isHidden = true
        endTextField.isHidden = true

        tableView.dataSource = self
//        tableView.separatorColor = .black
        tableView.delegate = self
        tableView.isHidden = true
        tableView.layer.cornerRadius = 8
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = .lightBackground
        // here

        view.addSubview(startButton)
        view.addSubview(endButton)
        view.addSubview(startTextField)
        view.addSubview(endTextField)
        view.addSubview(tableView)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        endButton.translatesAutoresizingMaskIntoConstraints = false
        startTextField.translatesAutoresizingMaskIntoConstraints = false
        endTextField.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Constraints for startButton
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.widthAnchor.constraint(equalToConstant: 144),  // Fixed width
            startButton.heightAnchor.constraint(equalToConstant: 44),  // Fixed height

            // Constraints for endButton
            endButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            endButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            endButton.widthAnchor.constraint(equalToConstant: 144),  // Fixed width
            endButton.heightAnchor.constraint(equalToConstant: 44),  // Fixed height

            // Constraints for startTextField
            startTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            startTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startTextField.heightAnchor.constraint(equalToConstant: 44),  // Fixed height

            // Constraints for endTextField
            endTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            endTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            endTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            endTextField.heightAnchor.constraint(equalToConstant: 44),  // Fixed height
            // Constraints for tableView
            tableView.topAnchor.constraint(equalTo: startTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    private func configureButton(_ button: UIButton, title: String) {
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
//        button.titleLabel?.font = .systemFont(ofSize: 20.0)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseForegroundColor = .lightGray
        configuration.baseBackgroundColor = .mainBackground
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0)
        button.configuration = configuration
        
    }

    private func configureTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .roundedRect
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.textColor =  .lightGray
        textField.backgroundColor = .lightBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
    }

    @objc private func startButtonTapped() {
        print("start button")
        isEditingStart = true
        toggleEditingMode(isEditing: true)
    }

    @objc private func endButtonTapped() {
        print("end button")
        isEditingStart = false
        toggleEditingMode(isEditing: true)
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text {
            filterValidPoints(with: text)
        } else {
            filterValidPoints(with: "")
        }
    }

    private func filterValidPoints(with searchText: String) {
        filteredPoints = validPoints.filter({ searchText.isEmpty ? true : $0.lowercased().contains(searchText.lowercased()) }).sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        tableView.reloadData()
    }

    func toggleEditingMode(isEditing: Bool) {
        guard let sheetPresentationController = presentationController as? UISheetPresentationController else {
            return
        }
        if isEditing {
            startButton.isHidden = true
            endButton.isHidden = true
            if isEditingStart {
                startTextField.isHidden = false
                startTextField.becomeFirstResponder()
                endTextField.isHidden = true
            } else {
                startTextField.isHidden = true
                endTextField.isHidden = false
                endTextField.becomeFirstResponder()
            }
            tableView.isHidden = false
            sheetPresentationController.animateChanges {
                sheetPresentationController.detents = [.small, .large()]
                sheetPresentationController.largestUndimmedDetentIdentifier = .small
                sheetPresentationController.selectedDetentIdentifier = .large
            }
            
        } else {
            startButton.isHidden = false
            endButton.isHidden = false
            startTextField.isHidden = true
            endTextField.isHidden = true
            startTextField.text = ""
            endTextField.text = ""
            filterValidPoints(with: "")
            startTextField.resignFirstResponder()
            endTextField.resignFirstResponder()
            tableView.isHidden = true
            sheetPresentationController.animateChanges {
                sheetPresentationController.detents = [.small]
                sheetPresentationController.largestUndimmedDetentIdentifier = .small
                sheetPresentationController.selectedDetentIdentifier = .small
                
            }
            
        }
    }
}



extension PathMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredPoints[indexPath.row]
        cell.textLabel?.textColor = .lightGray
        cell.backgroundColor = .lightBackground
//        cell.selectedBackgroundView?.backgroundColor = cell.backgroundColor
//        cell.selectedBackgroundView?.backgroundColor = cell.backgroundColor
//        cell.tintColor = .blue
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = cell.backgroundColor
        cell.selectedBackgroundView = selectedBackgroundView
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPoint = filteredPoints[indexPath.row]
        if isEditingStart {
            startButton.setTitle(selectedPoint, for: .normal)
            startPointValue = selectedPoint
            if startPointValue == endPointValue {
                endPointValue = nil
                endButton.setTitle(defaultEndTitle, for: .normal)
            }
        } else {
            endButton.setTitle(selectedPoint, for: .normal)
            endPointValue = selectedPoint
            if startPointValue == endPointValue {
                startPointValue = nil
                startButton.setTitle(defaultStartTitle, for: .normal)
            }
        }
        toggleEditingMode(isEditing: false)
    }
}


