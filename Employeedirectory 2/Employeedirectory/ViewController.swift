//
//  ViewController.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    let tableView = UITableView()
    
    var viewModel:EmployeeViewModel = EmployeeViewModel(withProtocol: NetworkService())
    
    let reuseIdentifierCell = "employeeTableViewCell"
    
    private let refreshControlTV = UIRefreshControl()
    
    var activityIndicator:NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = "Employee Directory"
//        self.navigationController?.navigationBar.titleTextAttributes
//        self.navigationController?.navigationBar.backgroundColor = .black
        let indicatorSize:CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.size.width - indicatorSize)/2, y: (view.frame.size.height - indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: .white, padding: 20.0)
        activityIndicator.backgroundColor = .black
        view.addSubview(activityIndicator)
        
        //load employee data from the server
        self.activityIndicator.startAnimating()
        viewModel.fetchEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json")
        
        //reload tableview whenever new employee data is fetched
        viewModel.reloadData = {[weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.reloadandDisplayView()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        self.setUpTableView()
    }
    
    
    
    //Do all settings related to table view here
    func setUpTableView() {
        self.view.addSubview(self.tableView)
        refreshControlTV.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControlTV.attributedTitle = NSAttributedString(string: "Refreshing Data...")
        self.tableView.refreshControl = refreshControlTV
        
        self.tableView.anchor(top: self.view.topAnchor , left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.size.width, height: self.view.frame.size.height, enableInsets: true)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: reuseIdentifierCell)
        
    }
    
    
    //MARK: - Refresh Data
    @objc private func refreshData(_ sender:Any) {
        viewModel.fetchEmployeeData(url: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")
    }
    
    func reloadandDisplayView() {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
}

// MARK: - TABLEVIEW DATASOURCE & DELEGATE
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print(self.viewModel.getEmployees()?.count)
        if(self.viewModel.getEmployees()?.count == 0) {
            //show view
            tableView.setEmptyView(title: "No Employees in the directory")
            
        } else {
            tableView.restore()
        }
        self.viewModel.sortEmployeesByTeam()
        return self.viewModel.getEmployees()?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! EmployeeTableViewCell
        cell.employeeTVCellVM = self.viewModel.getEmployeeData(at: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



