//
//  MainViewController.swift
//  StateViewController
//
//  Created by Santiago Desarrollo on 11/06/20.
//  Copyright © 2020 Santiago Desarrollo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class MainViewController: UIViewController {
    var state: tableState?  {
        didSet {
            self.tableview.reloadData()
        }
    }
    var tamano = 0
    
     // MARK: - Override Func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "tableview con estados"
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
            self.tamano = 10
            self.tableview.reloadData()
        }
        setupUI()
        
    }
    
     
     // MARK: - Func
    
    private func setupUI(){
        self.view.addSubview(tableview)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "recargar", style: .plain, target: self, action: #selector(changeState))
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    @objc func changeState(){
        let randomState = tableState.random()
        if randomState == .initial {
            self.tamano = 10
        } else {
            self.tamano = 0
        }
        state = randomState
    }
    
    
     // MARK: - UI
    lazy var tableview: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.tableFooterView = UIView()
        return table
    }()
    
}

 // MARK: - Table delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tamano
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hola"
        return cell
    }
    
    
}

 // MARK: - DZNE delegate

extension MainViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        switch state {
        case .empty:
            return MainViewController.emptyView
        case .noConnection:
            return MainViewController.noConnectionView
        case .error:
            return self.errorView(titulo: "Algo anda mal") { [weak self] (button) in
                button.isEnabled = false
                self?.changeState()
            }
        case .loading:
            return MainViewController.loadingView
        case .initial:
            return UIView()
        case .none:
            return self.errorView(titulo: "Error") { (_) in
                return
            }
        }
    }
    
}





