//
//  ViewController.swift
//  AlarmProject
//
//  Created by Mert Ziya on 21.01.2025.
//

import UIKit
import UserNotifications

class ManageSleepVC : UIViewController{
    
    
    
    // UI Elements:
    let tableView = UITableView()
    
    // Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
        
        
        if UserDefaults.standard.value(forKey: "SleepGoal") == nil{
            UserDefaults.standard.set(8.0, forKey: "SleepGoal")
        }
        
    }
    
    
}


extension ManageSleepVC : UITableViewDataSource, UITableViewDelegate {
    
    // we only need 2 items now because table view is simple.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HealthOptionsCell.id, for: indexPath) as? HealthOptionsCell else{
            print("DEBUG: Dequeue error")
            return UITableViewCell()
        }
              
        switch indexPath.row{
        case 0:
            cell.title.text = "Set Sleeping Goal"
            cell.healthBarIcon.image = UIImage(systemName: "scope")
            cell.healthBarIcon.tintColor = #colorLiteral(red: 0.9406209588, green: 0.3888850212, blue: 0.3805627227, alpha: 1)
        case 1:
            cell.healthBarIcon.image = UIImage(systemName: "bed.double")
            cell.healthBarIcon.tintColor = #colorLiteral(red: 0.3870307803, green: 0.9014505744, blue: 0.8826369643, alpha: 1)
            cell.title.text = "Set Sleep Schedule"
        default:
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc : UIViewController
        
        switch indexPath.row{
        case 0:
            vc = SleepGoalVC()
        case 1:
            vc = SleepScheduleVC()
        default:
            return
        }
        
        self.present(vc, animated: true)
    }
    
    
    private func setupTableView(){
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(HealthOptionsCell.self, forCellReuseIdentifier: HealthOptionsCell.id)
        tableView.selectionFollowsFocus = false
        tableView.alwaysBounceVertical = false
        tableView.layer.cornerRadius = 12
                
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 52 * 2),
            
            
        ])
    }
    
}



