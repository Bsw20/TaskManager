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
    private var service: CoreDataManager = CoreDataManager.shared
    private var tasks: [Task] = []
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        service.retrieveTasks(predicate: nil) {[weak self] (result) in
            switch result {
            
            case .success(let tasks):
                DispatchQueue.main.async {
                    self?.tasks = tasks
                    self?.table.reloadData()
                }
            case .failure(let error):
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        } 
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
                                                            action: #selector(plusButtonTapped))
        
        table.dataSource = self
        table.delegate = self
        table.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
        table.showsHorizontalScrollIndicator = false
        table.alwaysBounceVertical = true
        table.estimatedRowHeight = 66
        table.separatorStyle = .singleLine
    }
    
    private func updateTasks(result: Result<[Task], Error>) {
        switch result {
        
        case .success(let tasks):
            DispatchQueue.main.async {
                self.tasks = tasks
                self.table.reloadData()
            }
        case .failure(let error):
            UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
        }
    }
    //MARK: - Objc funcs
    @objc private func filterButtonTapped() {
        let ac = UIAlertController(title: "Filter tasks...", message: nil,
                                   preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Show new", style: .default)
        { [unowned self] _ in
            service.retrieveTasks(predicate: NSPredicate(format: "taskStatus == '\(TaskStatus.new.rawValue)'")) { (result) in
                updateTasks(result: result)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Show in process", style: .default)
        { [unowned self] _ in
            service.retrieveTasks(predicate: NSPredicate(format: "taskStatus == '\(TaskStatus.inProcess.rawValue)'")) { (result) in
                updateTasks(result: result)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Show completed", style: .default)
        { [unowned self] _ in
            service.retrieveTasks(predicate: NSPredicate(format: "taskStatus == '\(TaskStatus.completed.rawValue)'")) { (result) in
                updateTasks(result: result)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Show all", style: .default)
        { [unowned self] _ in
            service.retrieveTasks(predicate: nil) { (result) in
                updateTasks(result: result)
            }
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    //MARK: - Objc funcs
    @objc private func plusButtonTapped() {
        navigationController?.pushViewController(DetailsViewController(type: .createTask), animated: true)
    }
}

//MARK: - CollectionView Delegate&DataSource
extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else {
            fatalError("Can't cast to ImageCell")
        }
        cell.configure(model: tasks[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController(type: .editTask(task: tasks[indexPath.item]))
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
        let task = tasks[indexPath.item]
        tableView.beginUpdates()
        tasks.remove(at: indexPath.item)
        service.deleteTask(task: task)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        tableView.endUpdates()
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
