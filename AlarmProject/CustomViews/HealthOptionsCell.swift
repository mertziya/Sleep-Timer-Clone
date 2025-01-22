//
//  HealthOptionsCell.swift
//  AlarmProject
//
//  Created by Mert Ziya on 22.01.2025.
//

import Foundation
import UIKit

class HealthOptionsCell: UITableViewCell{
    
    static let id = "HealthCellId"
    
    let healthBarIcon = UIImageView()
    let clickIcon = UIImageView()
    let title = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
  
    
    private func setupUI(){
        addSubview(title)
        addSubview(healthBarIcon)
        addSubview(clickIcon)
        
        backgroundColor = #colorLiteral(red: 0.1098036841, green: 0.1098041013, blue: 0.1183908954, alpha: 1)
        
        
        title.textColor = .label
        
        clickIcon.image = UIImage(systemName: "chevron.right")
        clickIcon.tintColor = .systemGray2
        
        healthBarIcon.contentMode = .scaleAspectFit
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        healthBarIcon.translatesAutoresizingMaskIntoConstraints = false
        clickIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            healthBarIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            healthBarIcon.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            healthBarIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            healthBarIcon.widthAnchor.constraint(equalToConstant: 44),
            
            title.leftAnchor.constraint(equalTo: healthBarIcon.rightAnchor, constant: 12),
            title.centerYAnchor.constraint(equalTo: healthBarIcon.centerYAnchor),
            
            clickIcon.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            clickIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
        
    }
    
}
