//
//  SignUpViewController.swift
//  Task Tracker
//
//

import UIKit
import Foundation
import RealmSwift

class SignUpViewController: UIViewController {
    
    let firstnameField = UITextField()
    let lastnameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let usernameField = UITextField()
    let mobilenoField = UITextField()
    let signUpButton = UIButton()
    let errorLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    var email: String? {
        get {
            return emailField.text
        }
    }

    var password: String? {
        get {
            return passwordField.text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor =  #colorLiteral(red: 0.7882352941, green: 0.8862745098, blue: 0.3960784314, alpha: 1)
        

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

        
        //let imageName = "logo.png"
        //let image = UIImage(named: imageName)
        //let imageView = UIImageView(image: image!)
        //imageView.frame = CGRect(x: 120, y: 100, width: 200, height: 230)
        //Imageview on Top of View
        //self.view.addSubview(imageView)
        //container.addArrangedSubview(imageView)
        
        // Add some text at the top of the view to explain what to do.
        //let infoLabel = UILabel()
        //infoLabel.numberOfLines = 0
        //infoLabel.text = "Task Tracker"
        //infoLabel.textAlignment = .center
       // container.addArrangedSubview(infoLabel)

        // Configure the email and password text input fields.
        let infoLabel = UILabel()
        infoLabel.numberOfLines = 0
        infoLabel.text = "Registration"
        infoLabel.textAlignment = .center
        container.addArrangedSubview(infoLabel)
        
        firstnameField.placeholder = "FirstName"
        firstnameField.borderStyle = .roundedRect
        firstnameField.autocapitalizationType = .none
        firstnameField.autocorrectionType = .no
        container.addArrangedSubview(firstnameField)
        
        lastnameField.placeholder = "LastName"
        lastnameField.borderStyle = .roundedRect
        lastnameField.autocapitalizationType = .none
        lastnameField.autocorrectionType = .no
        container.addArrangedSubview(lastnameField)
        
        emailField.placeholder = "E-Mail address"
        emailField.borderStyle = .roundedRect
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        container.addArrangedSubview(emailField)
        
        usernameField.placeholder = "Username"
        usernameField.borderStyle = .roundedRect
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        container.addArrangedSubview(usernameField)

        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        container.addArrangedSubview(passwordField)
        
        
        mobilenoField.placeholder = "Mobile no."
        mobilenoField.borderStyle = .roundedRect
        mobilenoField.autocapitalizationType = .none
        mobilenoField.autocorrectionType = .no
        mobilenoField.keyboardType = .numberPad
        container.addArrangedSubview(mobilenoField)
        

        Utilities.styleFilledButton(signUpButton)
        signUpButton.setTitle("Sign Up", for: .normal);
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        container.addArrangedSubview(signUpButton)

        // Error messages will be set on the errorLabel.
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        container.addArrangedSubview(errorLabel)
    }

    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            mobilenoField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
            print("Sign up button tapped")
            
       
            // Validate required fields are not empty
            if (usernameField.text?.isEmpty)! ||
                (mobilenoField.text?.isEmpty)! ||
                (emailField.text?.isEmpty)! ||
                (passwordField.text?.isEmpty)!
            {
                // Display Alert message and return
                displayMessage(userMessage: "All fields are quired to fill in")
                return
            }
            
            // Validate password
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            displayMessage(userMessage: "Please make sure your password is at least 8 characters, contains a special character and a number.")
        }
            
            //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            
            // Position Activity Indicator in the center of the main view
            myActivityIndicator.center = view.center
            
            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
            myActivityIndicator.hidesWhenStopped = false
            
            // Start Activity Indicator
            myActivityIndicator.startAnimating()
            
            view.addSubview(myActivityIndicator)
            
            
            // Send HTTP Request to Register user
            let myUrl = URL(string: "http://13.232.149.111:8000/signup")
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "POST"// Compose a query string
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let postString = ["User_Name": usernameField.text!,
                              "First_Name": firstnameField.text!,
                              "Last_Name": lastnameField.text!,
                              "User_Email": emailField.text!,
                              "phone_no": mobilenoField.text!,
                              "password": passwordField.text!,
                              ] as [String: String]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
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
                return
            }
            
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    
                    let userId = parseJSON["User_Name"] as? String
                    print("User id: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)!
                    {
                        // Display an Alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    } else {
                        self.displayMessage(userMessage: "Successfully Registered a New Account. Please proceed to Sign in")
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
