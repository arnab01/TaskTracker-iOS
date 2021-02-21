//
//  CreateTaskViewController.swift
//  Task Tracker
//
//
import UIKit
import Foundation
import SwiftKeychainWrapper
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class CreateTaskViewController: UIViewController, UITextFieldDelegate {
    
    let titleField = MDCOutlinedTextField()
    let descriptionField = MDCOutlinedTextField()
    let priorityField = MDCOutlinedTextField()
    let planneddateField = MDCOutlinedTextField()
    let assigneeField = MDCOutlinedTextField()
    let reporterField = MDCOutlinedTextField()
    let statusField = MDCOutlinedTextField()
    let teamnameField = MDCOutlinedTextField()
    let createTaskButton = UIButton()
    let errorLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let crtask = TaskViewController()

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .secondarySystemBackground
        teamnameField.returnKeyType = .done
        titleField.delegate = self
        descriptionField.delegate = self
        priorityField.delegate = self
        planneddateField.delegate = self
        assigneeField.delegate = self
        reporterField.delegate = self
        statusField.delegate = self
        teamnameField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Create a view that will automatically lay out the other controls.
        let container = UIStackView();
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 16.0;
        view.addSubview(container)

        // Configure the activity indicator.
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        // Set the layout constraints of the container view and the activity indicator.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // This pins the container view to the top and stretches it to fill the parent
            // view horizontally.
            container.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            // The activity indicator is centered over the rest of the view.
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            ])


        // Configure the email and password text input fields.
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.text = "New Task"
        infoLabel.textAlignment = .center
        container.addArrangedSubview(infoLabel)
        
        titleField.placeholder = "Title"
        titleField.label.text = "Title"
        titleField.autocapitalizationType = .none
        titleField.autocorrectionType = .no
        container.addArrangedSubview(titleField)
        
        descriptionField.placeholder = "Description"
        descriptionField.label.text = "Description"
        descriptionField.autocapitalizationType = .none
        descriptionField.autocorrectionType = .no
        container.addArrangedSubview(descriptionField)
        
        priorityField.placeholder = "Priority"
        priorityField.label.text = "Priority"
        priorityField.autocapitalizationType = .none
        priorityField.autocorrectionType = .no
        container.addArrangedSubview(priorityField)
        
        planneddateField.placeholder = "Planned Date"
        planneddateField.label.text = "Planned Date"
        self.planneddateField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        container.addArrangedSubview(planneddateField)

        assigneeField.placeholder = "Assignee"
        assigneeField.label.text = "Assignee"
        assigneeField.autocapitalizationType = .none
        assigneeField.autocorrectionType = .no
        container.addArrangedSubview(assigneeField)
        
        statusField.placeholder = "Status"
        statusField.label.text = "Status"
        statusField.autocapitalizationType = .none
        statusField.autocorrectionType = .no
        container.addArrangedSubview(statusField)
        
        teamnameField.placeholder = "Team"
        teamnameField.label.text = "Team"
        teamnameField.autocapitalizationType = .none
        teamnameField.autocorrectionType = .no
        container.addArrangedSubview(teamnameField)
        

        Utilities.styleFilledButton(createTaskButton)
        createTaskButton.setTitle("Create Task", for: .normal);
        createTaskButton.addTarget(self, action: #selector(createTaskTapped), for: .touchUpInside)
        container.addArrangedSubview(createTaskButton)

        // Error messages will be set on the errorLabel.
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        container.addArrangedSubview(errorLabel)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 80
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleField {
               textField.resignFirstResponder()
               descriptionField.becomeFirstResponder()
            }else if textField == descriptionField {
                textField.resignFirstResponder()
                priorityField.becomeFirstResponder()
             }else if textField == priorityField {
                textField.resignFirstResponder()
                planneddateField.becomeFirstResponder()
             }else if textField == planneddateField {
                textField.resignFirstResponder()
                assigneeField.becomeFirstResponder()
             }else if textField == assigneeField {
                textField.resignFirstResponder()
                statusField.becomeFirstResponder()
            }else if textField == statusField {
                textField.resignFirstResponder()
                teamnameField.becomeFirstResponder()
            }else if textField == teamnameField {
                textField.resignFirstResponder()
            }
           return true
          }
    
    @objc func tapDone() {
            if let datePicker = self.planneddateField.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateStyle = .medium // 2-3
                self.planneddateField.text = dateformatter.string(from: datePicker.date) //2-4
            }
            self.planneddateField.resignFirstResponder() // 2-5
        }
    
    @IBAction func createTaskTapped(_ sender: Any) {
        
            let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
            print("create task button tapped")
            
       
            // Validate required fields are not empty
            if titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                priorityField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                planneddateField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                assigneeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                statusField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                teamnameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                // Display Alert message and return
                    displayMessage(userMessage: "All fields are required to fill in")
                
                return
            }
    
            
            //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            
            // Position Activity Indicator in the center of the main view
            myActivityIndicator.center = view.center
            
            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
            myActivityIndicator.hidesWhenStopped = false
            
            // Start Activity Indicator
            myActivityIndicator.startAnimating()
            
            view.addSubview(myActivityIndicator)
            
            
            // Send HTTP Request to createtask
            let myUrl = URL(string: "https://jedischoolteam3.tk/createtask")
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"// Compose a query string
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
            print("JWT \(accessToken!)")
            let postString = ["Title": titleField.text!,
                              "Description": descriptionField.text!,
                              "Priority": priorityField.text!,
                              "Planned_Date": planneddateField.text!,
                              "Assignee": assigneeField.text!,
                              "Reporter": "arnab02",
                              "Status": statusField.text!,
                              "Team_Name": teamnameField.text!,
                              ] as [String: String]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
                print("3020")
            } catch let error {
                print(error.localizedDescription)
                displayMessage(userMessage: "Something went wrong. Try again.")
                return
            }
            
         let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                print("2020")
                return
            }
            
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    let userId = parseJSON["Title"] as? String
                    if userId != nil {
                    print("User id: \(String(describing: userId!))")
                    }
                    
                    if (userId?.isEmpty)!
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        print("errrrrrror")
                        return
                    } else {
                       
                        self.displayMessage(userMessage: "Successfully created Task")
                    }
                    
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
            } catch {
                
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                // Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
                print("error2020")
            }
            }
            task.resume()
            
        }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
            {
                DispatchQueue.main.async
                 {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                }
            }
    
    func displayMessage(userMessage:String) -> Void {
            DispatchQueue.main.async
                {
                    let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        // Code in this block will trigger when OK button tapped.
                        print("Ok button tapped")
                        DispatchQueue.main.async
                            {
                                self.dismiss(animated: true, completion: nil)
                        }
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion:nil)
            }
        }
            
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
