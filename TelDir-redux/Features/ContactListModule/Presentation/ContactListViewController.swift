//
//  ViewController.swift
//  TelDir-redux
//
//  Created by Diana Princess on 14.02.2023.
//

import UIKit
import ReSwift

class ContactListViewController: UIViewController {
    
    struct ContactListViewProps {
        enum ContactListLoadResult {
            case success([ContactPresentationModel])
            case failure(Error)
            case notFinished
        }
        let isLoading: Bool
        let loadingResult: ContactListLoadResult
        
        init(state: ContactListState) {
            switch state.requestState {
            case .initial:
                self.loadingResult = .notFinished
                self.isLoading = false
            case .isLoading:
                self.isLoading = true
                self.loadingResult = .notFinished
            case .updated(let contacts):
                self.isLoading = false
                self.loadingResult = .success(contacts)
            case .failure(let error):
                self.isLoading = false
                self.loadingResult = .failure(error)
            }
        }
    }
    
    private let tableView = UITableView(frame: .zero)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
    private let nothingFoundLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = UIColor.darkGray
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.text = "По Вашему запросу ничего не найдено"
        return lbl
    }()
    
    private lazy var dataSource = createDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureViews()
        let action = HTTPRequest(method: .get, dataType: .contacts)
        mainStore.dispatch(action)
        // Do any additional setup after loading the view.
    }
    
    private func setRequestFailureView(error: Error){
        let alert = UIAlertController(title: "При выполнении запроса произошла ошибка", message: "Пожалуйста, проверьте подключение. Ошибка: "+error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Повторить попытку", style: UIAlertAction.Style.default){ _ in
            let action = HTTPRequest(method: .get, dataType: .contacts)
            mainStore.dispatch(action)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    private func render(props: ContactListViewProps) {
        props.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        switch props.loadingResult {
        case .success(let contacts):
            if contacts.count == 0 {
                nothingFoundLabel.isHidden = false
                tableView.isHidden = true
            } else {
                nothingFoundLabel.isHidden = true
                tableView.isHidden = false
                navigationController?.navigationBar.isHidden = false
                updateDataSource(contacts)
            }
        case .failure(let error):
            setRequestFailureView(error: error)
        case .notFinished:
            break
        }
    }
}

extension ContactListViewController: StoreSubscriber {
    
    typealias StoreSubscriberStateType = ContactListState
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self) {
            $0.select {
                $0.contactListState
            }
        }
        mainStore.dispatch(RoutingAction(navigationState: .initial))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }

    func newState(state: ContactListState) {
        let props = ContactListViewProps(state: state)
        DispatchQueue.main.async {
            self.render(props: props)
        }
    }
}

// MARK: - Set up UI
extension ContactListViewController {
    private func configureViews() {
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseId)
        tableView.dataSource = dataSource
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ (maker) in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        tableView.isHidden = true
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints{ (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        view.addSubview(nothingFoundLabel)
        nothingFoundLabel.snp.makeConstraints{ (maker) in
            maker.centerX.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().inset(30)
            maker.height.equalTo(50)
        }
        nothingFoundLabel.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск контактов"
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Diffable Data source for TableView
extension ContactListViewController {
    private func createDataSource() -> UITableViewDiffableDataSource<String, ContactPresentationModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: { tableView,indexPath,contact in
                let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseId, for: indexPath) as! ContactTableViewCell
                let defaultImage = UIImage(systemName: "person.fill")!
                switch contact.thumbnail.state {
                case .notDownloaded:
                    cell.configure(fullName: contact.fullname, photo: defaultImage, photoStatus: contact.thumbnail.state)
                    let action = HTTPRequest(resource: contact.thumbnailString, method: .get, dataType: .contacts)
                    mainStore.dispatch(action)
                case .downloaded(let data):
                    let image = UIImage(data: data)!
                    cell.configure(fullName: contact.fullname, photo: image, photoStatus: contact.thumbnail.state)
                case .failed:
                    cell.configure(fullName: contact.fullname, photo: defaultImage, photoStatus: contact.thumbnail.state)
                }
                return cell
            }
        )
    }
    
    private func updateDataSource(_ contacts: [ContactPresentationModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, ContactPresentationModel>()
        snapshot.appendSections(["1"])
        snapshot.appendItems(contacts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: TableView Delegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let contactPresentationModel = dataSource.snapshot().itemIdentifiers[indexPath.row]
            let id = contactPresentationModel.id
            let routingAction = RoutingAction(navigationState: .oneContact)
            mainStore.dispatch(routingAction)
            let action = UpdateOneContactAction(id: id)
            mainStore.dispatch(action)
//            presenter?.openContact(id: id)
        }
    }
}

extension ContactListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        (searchController.searchBar.text?.isEmpty ?? true) ? mainStore.dispatch(DeactivateFilteringAction()) : mainStore.dispatch(ContactListFilterAction(filterString: searchController.searchBar.text!))
    }
}

