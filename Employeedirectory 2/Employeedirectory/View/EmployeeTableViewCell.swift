//
//  EmployeeTableViewCell.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
    static let identifier = "EmployeeTableViewCell"
    
    var employeeTVCellVM:EmployeeTVCellViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.nameLabel.text = self.employeeTVCellVM?.name()
                self.teamLabel.text = self.employeeTVCellVM?.team()
                self.loadandShowImage()
            }
        }
    }
        
     private let employeeImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
     private let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     private let teamLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
         label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - INITIALIZATION METHODS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(employeeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(teamLabel)
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        let employeeImageViewConstraints = [employeeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                            employeeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 15),
                                            employeeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -15),
                                            employeeImageView.widthAnchor.constraint(equalToConstant: 100)]
        
        let nameLabelConstraints = [nameLabel.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                    nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                                    nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20)]
        
        let teamLabelConstraints = [teamLabel.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                    teamLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                                    teamLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: -20),
                                    teamLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)]
        
        
        NSLayoutConstraint.activate(employeeImageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(teamLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - POPULATE IMAGE
    
    func loadandShowImage() {
        employeeTVCellVM?.getSmallImage(completion: {[weak self] image in
            DispatchQueue.main.async {
                self?.employeeImageView.image = image
            }
        })
    }
}
