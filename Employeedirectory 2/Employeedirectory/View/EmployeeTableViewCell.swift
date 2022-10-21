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
                self.emailLabel.text = self.employeeTVCellVM?.employeeData?.email_address
                self.phoneLabel.text = self.employeeTVCellVM?.employeeData?.phone_number
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
    
    private let emailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "e.circle"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailLabel : UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 10)
       label.textAlignment = .left
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    private let phoneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.circle"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let phoneLabel : UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 10)
       label.textAlignment = .left
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
    
    
    //MARK: - INITIALIZATION METHODS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        backgroundColor = .clear
//        contentView.backgroundColor = .clear
        contentView.addSubview(employeeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(teamLabel)
        contentView.addSubview(emailButton)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneButton)
        contentView.addSubview(phoneLabel)
        
        phoneButton.addTarget(self, action:#selector(self.callPerson), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(self.emailPerson), for: .touchUpInside)
       
        
        self.applyConstraints()
    }
    
    func applyConstraints() {
        let employeeImageViewConstraints = [employeeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                            employeeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 15),
                                            employeeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -15),
                                            employeeImageView.widthAnchor.constraint(equalToConstant: 100)]
        
        let nameLabelConstraints = [nameLabel.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                    nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                                    nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
                                    nameLabel.heightAnchor.constraint(equalToConstant: 20)]
        
        let teamLabelConstraints = [teamLabel.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                    teamLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                                    teamLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 1),
                                    teamLabel.heightAnchor.constraint(equalToConstant: 20)]
        
        
        let emailButtonConstraints = [emailButton.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                      emailButton.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 1),
                                      emailButton.widthAnchor.constraint(equalToConstant: 20),
                                      emailButton.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor)]
        
        let emailLabelConstraints = [emailLabel.leadingAnchor.constraint(equalTo: emailButton.trailingAnchor, constant: 5),
                                     emailLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -10),
                                     emailLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 1),
                                     emailLabel.heightAnchor.constraint(equalToConstant: 20)]
        
        let phoneButtonConstraints = [phoneButton.leadingAnchor.constraint(equalTo: self.employeeImageView.trailingAnchor, constant: 20),
                                      phoneButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 1),
                                      phoneButton.widthAnchor.constraint(equalToConstant: 20),
                                      phoneButton.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor)]
        
        let phoneLabelConstraints = [phoneLabel.leadingAnchor.constraint(equalTo: phoneButton.trailingAnchor, constant: 5),
                                     phoneLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                                     phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 1),
                                     phoneLabel.heightAnchor.constraint(equalToConstant: 20)]
        
        
        NSLayoutConstraint.activate(employeeImageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(teamLabelConstraints)
        
        NSLayoutConstraint.activate(emailButtonConstraints)
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(phoneButtonConstraints)
        NSLayoutConstraint.activate(phoneLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - UIButton Action
    @objc func callPerson(_ sender:UIButton) {
        self.employeeTVCellVM?.call()
    }
    
    @objc func emailPerson(_ sender:UIButton) {
        self.employeeTVCellVM?.email()
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
