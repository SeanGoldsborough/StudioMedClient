//
//  CalendarVC.swift
//  StudioMedDatabase
//
//  Created by Sean Goldsborough on 5/17/18.
//  Copyright © 2018 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar
//
//protocol getDateDelegate {
//    func selectedDate(date: String, selected: Date)
//}

class CalendarVC: UIViewController {
    
    var delegate:GetDataProtocol?
    var appointment = AppointmentData.sharedInstance

    @IBAction func sendData(_ sender: Any) {
        appointment.date = "\(selectedDate.text!)"
        print("appt date is: \(appointment.date)")
        //delegate?.setResultOfGetDate(valueSent: textField.text!)
        //self.navigationController?.popViewController(animated: true)
        let requestTimeVC = storyboard?.instantiateViewController(withIdentifier: "RequestTimeVC") as! RequestTimeVC
        //listOfAppointmentsVC.userName = fullName
        self.navigationController?.pushViewController(requestTimeVC, animated: true)
    }
    
    let preDateSelectable: Bool = false
    
   // var delegate: getDateDelegate!
    
    let outsideMonthColor = UIColor(hex: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(hex: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(hex: 0x4e3f5d)
    var selected = Date()
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var gradView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearView: UIView!
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func pushDateData(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let date = "\(self.selected)"
        //        nextVC.dateLabel.text = date
        //        navigationController?.pushViewController(nextVC, animated: true)
    }
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height)
        
        layer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
        layer.opacity = 0.3
        view.layer.addSublayer(layer)
        
        setupCalendarView()
        setupTopStackView()
        setupLabels()
        setupButtons()
    }
    
    
    
    func setupTopStackView() {
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            topStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topStackView.widthAnchor.constraint(equalToConstant: 315),
            topStackView.heightAnchor.constraint(equalToConstant: 433)
            ])
    }
    
    func setupButtons() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            doneButton.bottomAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: -8),
            doneButton.trailingAnchor.constraint(equalTo: self.topStackView.trailingAnchor, constant: -24),
            
            cancelButton.bottomAnchor.constraint(equalTo: self.topStackView.bottomAnchor, constant: -8),
            cancelButton.trailingAnchor.constraint(equalTo: self.doneButton.leadingAnchor, constant: -24)
            ])
    }
    
    func setupLabels() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        yearView.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        selectedDate.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            yearView.topAnchor.constraint(equalTo: self.topStackView.topAnchor),
            yearView.heightAnchor.constraint(equalToConstant: 50),
            yearView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0),
            
            monthLabel.centerYAnchor.constraint(equalTo: self.yearView.centerYAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: self.yearView.centerXAnchor),
            
            dateView.topAnchor.constraint(equalTo: self.yearView.bottomAnchor, constant: 8),
            dateView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0),
            
            selectedDate.centerYAnchor.constraint(equalTo: self.dateView.centerYAnchor),
            selectedDate.centerXAnchor.constraint(equalTo: self.dateView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.dateView.bottomAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: topStackView.widthAnchor, multiplier: 0)
            ])
    }
    
    func setupCalendarView() {
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.scrollToDate(selected, animateScroll: false)
        calendarView.selectDates([selected])
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        monthLabel.text = "\(month) \(year)"
    }
    
    func setDate(date: Date) {
        let formatters = DateFormatter()
        //formatters.dateFormat = "MMM d, yyyy"
        formatters.dateFormat = "MM/dd/yyyy"
        //formatters.dateFormat = "MMM d, yyyy - h:mm a"
        self.selected = date
        selectedDate.text = formatters.string(from: date)
        print("selected date text from setDate is: \(selectedDate.text)")
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCollectionViewCell else { return }
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.darkGray
        } else {
            
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        
//        self.delegate?.selectedDate(date: selectedDate.text!, selected: self.selected)
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState, date: Date) {
        guard let validCell = view as? CalendarCollectionViewCell else { return }
        
        if cellState.dateBelongsTo != .thisMonth {
            validCell.dateLabel.text = ""
            validCell.isUserInteractionEnabled = false
            validCell.selectedView.isHidden = true
        } else if date.isSmaller(to: Date()) && !preDateSelectable {
            validCell.dateLabel.text = "-"
            validCell.isUserInteractionEnabled = false
            validCell.selectedView.isHidden = true
        } else {
            
            validCell.isUserInteractionEnabled = true
            if cellState.isSelected {
                view?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0, usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 0.1,
                    options: UIViewAnimationOptions.beginFromCurrentState,
                    animations: {
                        view?.transform = CGAffineTransform(scaleX: 1, y: 1)
                },
                    completion: { _ in
                })
                
                validCell.selectedView.isHidden = false
            } else {
                validCell.selectedView.isHidden = true
            }
            validCell.dateLabel.text = cellState.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        let endDate = formatter.date(from: "2050 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate!)
        
        return parameters
    }
}

extension CalendarVC: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CalendarCollectionViewCell
        //configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        handleCellSelected(view: cell, cellState: cellState, date: date)
    }
    
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        setDate(date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        handleCellSelected(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}



