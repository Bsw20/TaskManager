//
//  DetailsViewController.swift
//  TaskManager
//
//  Created by Ярослав Карпунькин on 05.03.2021.
//

import Foundation
import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    enum ViewType {
        case createTask
        case editTask(task: Task)
    }
    
    //MARK: - Variables
    private var model: Task
    private var type: ViewType
    private var service: CoreDataManager = CoreDataManager.shared
    
    //MARK: - Controls
    private var titleTextView: TextFieldView = TextFieldView(placeholder: "Название")
    private var commentTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 23, left: 24, bottom: 24, right: 23)
        textView.clipsToBounds = true
        return textView
    }()
    
    private var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.date = Date()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    private var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: TaskStatus.allCases.map{$0.description()})
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    //MARK: - Lyfycycle
    init(type: ViewType) {
        self.type = type
        switch type {
        
        case .createTask:
            model = service.initNewTask()
        case .editTask(task: let task):
            model = task
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        setupConstraints()
        
        
    }
    
    //MARK: - Funcs
    private func configure() {
//        datePicker?.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
    }
    
    //MARK: - Objc funcs
//    @objc private func handleDateSelection
}

//MARK: - Constraints
extension DetailsViewController {
    private func setupConstraints() {
        view.addSubview(titleTextView)
        view.addSubview(commentTextView)
        view.addSubview(datePicker)
        view.addSubview(segmentedControl)
        
        titleTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
    }
}
