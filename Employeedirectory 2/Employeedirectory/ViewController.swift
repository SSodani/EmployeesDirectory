//
//  ViewController.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    let employeeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        return tableView
    }()
    
    let activityIndicator:NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(frame: .zero, type: .lineScale, color: .white, padding: 20.0)
        indicator.backgroundColor = .black
        return indicator
    }()
    
    private let refreshControlTV: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data...")
        return refreshControl
    }()
    
    
    var viewModel:EmployeeViewModel? {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
                self?.employeeTableView.refreshControl?.endRefreshing()
                self?.employeeTableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Employee List"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        refreshControlTV.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        view.addSubview(self.employeeTableView)
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.refreshControl = refreshControlTV
        
        view.addSubview(activityIndicator)
        
        self.fetchEmployeeData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        employeeTableView.frame = self.view.bounds
        activityIndicator.frame =  CGRect(x: (view.frame.size.width - 70)/2, y: (view.frame.size.height - 70)/2, width: 70, height: 70)
    }
    

    func fetchEmployeeData() {
        self.activityIndicator.startAnimating()
        NetworkService.shared.getEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees.json") {[weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let employeeDataArray):
                self?.viewModel = EmployeeViewModel.init(with: employeeDataArray)
            }
        }
    }
    

    
    //MARK: - Refresh Data
    @objc private func refreshData(_ sender:Any) {
        self.fetchEmployeeData()
    }
    
    
}

// MARK: - TABLEVIEW DATASOURCE & DELEGATE
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.viewModel?.sortEmployeesByName()
        
        guard let employeeDataArray = self.viewModel?.getEmployees(),
              employeeDataArray.count > 0 else {
                  tableView.setEmptyView(title: "No Employees in the directory")
                  return 0
              }
        
        tableView.restore()
        return employeeDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as? EmployeeTableViewCell else {
            return UITableViewCell()
        }
        cell.employeeTVCellVM = self.viewModel?.getEmployeeData(at: indexPath)
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //move navigation bar as scrolls to top of tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = self.view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffSet
        
        navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: 0, y: min(0, -offset))
    }
}



