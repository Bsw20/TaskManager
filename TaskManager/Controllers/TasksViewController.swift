//
//  TasksViewController.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit
import SnapKit

class TasksViewController: UIViewController {
    //MARK: - Variables
    //MARK: - Contols
    private var table: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupConstraints()
    }
    
    //MARK: - Funcs
    private func setupUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        navigationItem.title = "Задачи"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(systemName: "line.horizontal.3.decrease.circle") ,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(.lightGray),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterButtonTapped))
        
        table.dataSource = self
        table.delegate = self
        table.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        table.showsHorizontalScrollIndicator = false
        table.alwaysBounceVertical = true
        table.estimatedRowHeight = 66
        table.separatorStyle = .singleLine
    }
    
    //MARK: - Objc funcs
    @objc private func filterButtonTapped() {
        print(#function)
    }
    
    //MARK: - Objc funcs
    @objc private func plusButtonTapped() {
        print(#function)
    }
}

//MARK: - CollectionView Delegate&DataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else {
            fatalError("Can't cast to ImageCell")
        }
//        cell.configure(model: model.images[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController(type: .createTask)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            fatalError()
        }
        // удаление ячейки + удаление из модели
        tableView.beginUpdates()
        
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        
//        eventsList.remove(at: indexPath.row)
//        event.saveData()
        tableView.endUpdates() //завершить обновление

//        delegate?.refreshUI() // обновить родительское окно
    }
    
}


//MARK: - Constraints
extension TasksViewController {
    private func setupConstraints() {
        view.addSubview(table)
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
