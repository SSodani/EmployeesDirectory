//
//  EmployeeTableViewCell.swift
//  Employeedirectory
//
//  Created by Sonam Sodani on 2022-10-06.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
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
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let teamLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    //MARK: - INITIALIZATION METHODS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(employeeImageView)
        addSubview(nameLabel)
        addSubview(teamLabel)
        
        employeeImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        nameLabel.anchor(top: topAnchor, left: employeeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        teamLabel.anchor(top: nameLabel.bottomAnchor, left: employeeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - POPULATE IMAGE
    
    func loadandShowImage() {
        employeeTVCellVM?.getImage(completion: {[weak self] image in
            DispatchQueue.main.async {
                self?.employeeImageView.image = image
            }
            
        })
    }
    
    
    
    
}
