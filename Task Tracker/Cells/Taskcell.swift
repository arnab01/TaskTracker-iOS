//
//  Taskcell.swift
//  Task Tracker
//
//

import UIKit

class Taskcell: UITableViewCell {
    
    private var title: MILabel!
    private var moreInfoLabel: MILabel!
    private var ratingLabel: MILabel!
    private var Priority: MILabel!
    private var Planneddate: MILabel!

    
    static let reuseID = "Cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .secondarySystemBackground
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(with task: Tasks) {
        self.title.text = task.Title
        self.title.textColor = UIColor.purple
        if let rating = task.Priority {
            self.ratingLabel.text = "Priority: \(String(rating))"
            self.ratingLabel.textColor = UIColor.black
        } else {
            self.ratingLabel.text = "N/A"
            self.ratingLabel.textColor = UIColor.black
        }
        if let desc = task.Description {
            self.moreInfoLabel.text = "\(desc)"
            self.moreInfoLabel.textColor = UIColor.black
        } else {
            self.moreInfoLabel.text = "No description"
            self.moreInfoLabel.textColor = UIColor.black
        }
        if let prior = task.Status {
            self.Priority.text = "Status: \(prior)"
            self.Priority.textColor = UIColor.black
        } else {
            self.Priority.text = "Status Unknown"
            self.Priority.textColor = UIColor.black
        }
        if let date = task.plannedDate {
            //self.Planneddate.text = "Deadline: \(String(date))"
            //self.Planneddate.textColor = UIColor.black
        }
        else {
            //self.Planneddate.text = "Deadline: Unassigned"
            //self.Planneddate.textColor = UIColor.black
        }
        
    }
    
    private func setupComponents()  {
        self.selectedBackgroundView = UIView()
        //self.selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        //configureMovieImage()
        configureText()
    }
    
    override func prepareForReuse() {
        self.title.text = ""
        self.ratingLabel.text = "N/A"
        self.moreInfoLabel.text = ""
        //self.Planneddate.text = ""
       //self.movieImage.setPlaceHolder()
    }

    
    private func configureText() {
        title = MILabel(font: .preferredFont(forTextStyle: .headline), textColor: .label)
        moreInfoLabel = MILabel()
        ratingLabel = MILabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .label)
        Priority = MILabel(font: .preferredFont(forTextStyle: .subheadline), textColor: .label)
        //TaskId = MILabel()
        
        addSubview(title)
        addSubview(moreInfoLabel)
        addSubview(ratingLabel)
        addSubview(Priority)
        //addSubview(Planneddate)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        moreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        Priority.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            title.heightAnchor.constraint(equalToConstant: 25),
            
            moreInfoLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            //moreInfoLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            moreInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            moreInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            moreInfoLabel.heightAnchor.constraint(equalToConstant: 25),
            
            //Planneddate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            //moreInfoLabel.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 20),
            //Planneddate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            //Planneddate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            //Planneddate.widthAnchor.constraint(equalToConstant: 275),
            //Planneddate.heightAnchor.constraint(equalToConstant: 25),
            
            Priority.topAnchor.constraint(equalTo: moreInfoLabel.bottomAnchor, constant: 10),
            Priority.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            Priority.widthAnchor.constraint(equalToConstant: 275),
            Priority.heightAnchor.constraint(equalToConstant: 25),
            
            ratingLabel.centerYAnchor.constraint(equalTo: Priority.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: Priority.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ratingLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

