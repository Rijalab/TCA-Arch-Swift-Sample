//
//  ViewController.swift
//  TCA-SampleArchitecture
//
//  Created by Ramakrishnan, Balaji (Cognizant) on 11/07/24.
//

import UIKit
import ComposableArchitecture

struct CalcRow {
    var title : String
    var value : AnyObject?
}

@MainActor
let dataSource : [CalcRow] = [
    CalcRow(title: "Pick Date of Birth", value: nil),
    CalcRow(title: "Years", value: nil),
    CalcRow(title: "Months", value: nil),
    CalcRow(title: "Days", value: nil),
    CalcRow(title: "Hour", value: nil),
    CalcRow(title: "Minutes", value: nil),
    CalcRow(title: "Seconds", value: nil)
]

class CalculatorViewController: UITableViewController {
    
    var store : StoreOf<AgeCalculatorFeature>
            
    init(store: StoreOf<AgeCalculatorFeature>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func calculateButtonAction(sender: UIBarButtonItem) {
        store.send(.calculateAge)
    }
    
    @objc func clearButtonAction(sender: UIBarButtonItem) {
        store.send(.clearData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calcButton = UIBarButtonItem(title: "Calculate", style: .done, target: self, action: #selector(calculateButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = calcButton
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(clearButtonAction(sender:)))
        self.navigationItem.leftBarButtonItem = clearButton
        
        self.navigationItem.title = "Age calculator"
        
        observe { [weak self] in
            guard let self else { return }
            
            calcButton.isEnabled = store.birthdate != nil
            
            let _ = store.ageInYears
            let _ = store.ageInMonths
            let _ = store.ageInDays
            let _ = store.ageInHours
            let _ = store.ageInMins
            let _ = store.ageInSecs
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        var content = cell.defaultContentConfiguration()
        
        let row = dataSource[indexPath.row]

        switch indexPath.row {
        
        case 0:
            content.text = row.title
            content.secondaryText = store.birthdate?.toString(format: "dd/MMM/yyyy")
            cell.accessoryType = .disclosureIndicator
        case 1:
            content.text = store.ageInYears?.formatted()
            content.secondaryText = row.title
        case 2:
            content.text = store.ageInMonths?.formatted()
            content.secondaryText = row.title
        case 3:
            content.text = store.ageInDays?.formatted()
            content.secondaryText = row.title
        case 4:
            content.text = store.ageInHours?.formatted()
            content.secondaryText = row.title
        case 5:
            content.text = store.ageInMins?.formatted()
            content.secondaryText = row.title
        case 6:
            content.text = store.ageInSecs?.formatted()
            content.secondaryText = row.title
            
        default:
            break
        }
        
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let alertVc = UIAlertController(title: "Pick Date of Birth", message: "\n\n\n\n", preferredStyle: .actionSheet)
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            
            var pickerFrame = datePicker.frame
            pickerFrame.size.height = datePicker.frame.size.height + 100
            datePicker.frame = pickerFrame
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                let selectedDate = datePicker.date
                self.store.send(.updateBirthdate(date: selectedDate))
                self.dismiss(animated: true)
            }
            alertVc.addAction(okAction)
            alertVc.view.addSubview(datePicker)
            
            self.present(alertVc, animated: true)
        }
    }
}
