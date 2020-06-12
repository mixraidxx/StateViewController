//
//  CollectionViewController.swift
//  StateViewController
//
//  Created by Santiago Desarrollo on 11/06/20.
//  Copyright © 2020 Santiago Desarrollo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Lottie


class CollectionViewController: UIViewController {
    var state: tableState?  {
        didSet {
            self.tableview.reloadData()
        }
    }
    var tamano = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "tableview con estados"
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(3000)) {
            print("BOOYAH!")
            self.tamano = 10
            self.tableview.reloadData()
        }
        setupUI()
        
    }
    
    
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
        print(randomState)
        state = randomState
        if randomState == .initial {
            self.tamano = 10
        } else {
            self.tamano = 0
        }
        self.tableview.reloadData()
    }
    
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

extension CollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tamano
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hola"
        return cell
    }
    
    
}

extension CollectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        switch state {
        case .empty:
            return CollectionViewController.emptyView
        case .noConnection:
            return CollectionViewController.noConnectionView
        case .error:
            return self.errorView(titulo: "Algo anda mal") { [weak self] (button) in
                button.isEnabled = false
                self?.changeState()
            }
        case .loading:
            return CollectionViewController.loadingView
        case .initial:
            return UIView()
        case .none:
            return self.errorView(titulo: "Error") { (_) in
                return
            }
        }
    }
    
}

extension CollectionViewController {
    
    open class var emptyView: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "empty")
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vacio"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        // view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return view
    }
    
    static let noConnectionView: UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "no internet")
        imageView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sin conexión"
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(imageView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        // view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return view
    }()
    
    func errorView(titulo: String,handler: @escaping ((UIButton) -> Void)) -> UIView  {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "error")
        imageView.contentMode = .scaleAspectFit
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reintentar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1843137255, green: 0.7568627451, blue: 0.6078431373, alpha: 1)
        button.addAction(for: .touchUpInside) { (_) in
            handler(button)
        }
        button.layer.cornerRadius = 8
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = titulo
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        // view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return view
    }
    
    open class var loadingView: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let animationView = AnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        let file = Animation.named("loading")
        animationView.animation = file
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.loopMode = .loop
        animationView.play()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cargando"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(animationView)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 300),
            animationView.heightAnchor.constraint(equalToConstant: 200),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: animationView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: animationView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: animationView.trailingAnchor)
            
        ])
        // view.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return view
    }
    
    
    
}

enum tableState: CaseIterable {
    case noConnection
    case error
    case empty
    case loading
    case initial
    
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> tableState {
        return tableState.allCases.randomElement(using: &generator)!
    }
    
    static func random() -> tableState {
        var g = SystemRandomNumberGenerator()
        return tableState.random(using: &g)
    }
}

extension UIControl {

    public typealias UIControlTargetClosure = (UIControl) -> ()
    
    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIControlClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }
    
}
