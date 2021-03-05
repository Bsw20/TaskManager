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
        sc.selectedSegmentIndex = 0
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
        switch type {
        case .createTask:
            break
        case .editTask(task: let task):
            guard let status = task.taskStatus,
                  let index = TaskStatus.init(rawValue: status)?.index(),
                  let title = task.title,
                  let comment = task.comment,
                  let date = task.date else {
                fatalError("incorrect model")
            }
            segmentedControl.selectedSegmentIndex = index
            titleTextView.setText(newText: title)
            datePicker.setDate(date, animated: false)
            commentTextView.text = comment
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    //MARK: - Objc funcs
    @objc private func saveButtonTapped() {
        guard !titleTextView.isEmpty() && commentTextView.text != "" && commentTextView.text != nil else {
            UIApplication.showAlert(title: "Ошибка!", message: "Не все поля заполнены")
            return
        }
        model.date = datePicker.date
        model.title = titleTextView.getText()
        model.taskStatus = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        model.comment = commentTextView.text
        service.saveContext { [weak self](result) in
            switch result {
            
            case .success():
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
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
            make.height.equalTo(40)
        }
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(datePicker.snp.bottom)
            make.height.equalTo(40)
        }
        
        commentTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(segmentedControl)
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
    }
}
