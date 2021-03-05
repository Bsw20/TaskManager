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
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.reuseId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.alwaysBounceHorizontal = true
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
extension TasksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.reuseId, for: indexPath) as? TaskCell else {
            fatalError("Can't cast to ImageCell")
        }
//        cell.configure(model: model.images[indexPath.item])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TasksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: , height: 66)
    }
}

//MARK: - Constraints
extension TasksViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
