//
//  MainViewController.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 28.04.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return table
    }()
    
    // Для сокращения времени разработки сделал без DI, на реальном проекте конечно собрал бы модуль по частям и прокидывал через флоу координатор/роутер.
    private var viewModel = MainViewModel()
    private var bag = DisposeBag()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableData()
        bindNotifications()
    }
    
    @objc func addButtonTapped() {
        appDelegate?.sendMockNotification()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func bindTableData() {
        
        viewModel.players.bind(to: tableView.rx.items(cellIdentifier: UITableViewCell.identifier, cellType: UITableViewCell.self)) { (row,model,cell) in
            cell.textLabel?.text = model.name
        }.disposed(by: bag)
        
        viewModel.fetchPlayers { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func bindNotifications() {
        appDelegate?.notificationsSubject
            .subscribe(onNext: { event in
                if event == R.string.localizable.tableNeedsUpdate() {
                    // по задумке здесь должен вызываться основной метод модельвью fetchPlayers, который должен сделать новый запрос. Но пока нет бека, для наглядности, поставил моковый метод со статичным массивом данных.
                    self.viewModel.fetchUpdatedPlayers()
                }
            })
            .disposed(by: bag)
    }
}


