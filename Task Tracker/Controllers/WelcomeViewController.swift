//
//  WelcomeViewController.swift
//  Task Tracker
//
//

import UIKit
import SwiftKeychainWrapper
import MaterialComponents.MaterialTextControls_OutlinedTextFields

// The WelcomeViewController handles login and account creation.
class WelcomeViewController: UIViewController, UITextFieldDelegate {
    let usernameField = MDCOutlinedTextField()
    let passwordField = MDCOutlinedTextField()
    let signInButton = UIButton()
    let signUpButton = UIButton()
    let errorLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var isLoadingMovies = false

    var email: String? {
        get {
            return usernameField.text
        }
    }

    var password: String? {
        get {
            return passwordField.text
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .secondarySystemBackground
        passwordField.delegate = self
        passwordField.returnKeyType = .done
        usernameField.delegate = self
        self.navigationItem.hidesBackButton = true
        
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
            container.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            // The activity indicator is centered over the rest of the view.
            activityIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            ])

        
        let imageName = "logo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 120, y: 100, width: 200, height: 230)
        //Imageview on Top of View
        self.view.addSubview(imageView)
        //container.addArrangedSubview(imageView)
        
        

        // Configure the email and password text input fields.
        usernameField.placeholder = "Username"
        usernameField.label.text = "Username"
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.sizeThatFits(CGSize(width: 30, height: 10))
        container.addArrangedSubview(usernameField)

        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.label.text = "Password"
        container.addArrangedSubview(passwordField)

        // Configure the sign in and sign up buttons.
        Utilities.styleFilledButton(signInButton)
        signInButton.setTitle("Sign In", for: .normal);
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        container.addArrangedSubview(signInButton)

        Utilities.styleFilledButton(signUpButton)
        signUpButton.setTitle("Sign Up", for: .normal);
        signUpButton.addTarget(self, action: #selector(signUpButtonDidClick), for: .touchUpInside)
        container.addArrangedSubview(signUpButton)

        // Error messages will be set on the errorLabel.
        errorLabel.numberOfLines = 0
        errorLabel.textColor = .red
        container.addArrangedSubview(errorLabel)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 25
            }
        }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    // Turn on or off the activity indicator.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
               textField.resignFirstResponder()
               passwordField.becomeFirstResponder()
            }else if textField == passwordField {
               textField.resignFirstResponder()
            }
           return true
          }
        
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating();
            errorLabel.text = "";
        } else {
            activityIndicator.stopAnimating();
        }
        usernameField.isEnabled = !loading
        passwordField.isEnabled = !loading
        signInButton.isEnabled = !loading
        signUpButton.isEnabled = !loading
    }

    
    
    @objc func signUpButtonDidClick() {
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func signInButtonTapped(_ sender: Any) {
            print("Sign in button tapped")
            
            // Read values from text fields
            let userName = usernameField.text
            let userPassword = passwordField.text
            
            // Check if required fields are not empty
            if (userName?.isEmpty)! || (userPassword?.isEmpty)!
            {
                // Display alert message here
                print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
                displayMessage(userMessage: "One of the required fields is missing")
                
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
            
            
            //Send HTTP Request to perform Sign in
            let myUrl = URL(string: "https://jedischoolteam3.tk/login")
            var request = URLRequest(url:myUrl!)
           
            request.httpMethod = "POST"// Compose a query string
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let postString = ["User_Name": userName!, "password": userPassword!] as [String: String]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                displayMessage(userMessage: "Something went wrong...")
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
                        
                        if parseJSON["errorMessageKey"] != nil
                        {
                             self.displayMessage(userMessage: parseJSON["errorMessage"] as! String)
                            return
                        }
                        
                        
                        
                        if parseJSON["refresh_token"] != nil {
                        // Now we can access value of First Name by its key
                        let refreshToken = parseJSON["refresh_token"] as? String
                        //print("Access token: \(String(describing: accessToken!))")
                        
                        let saveRefreshToken: Bool = KeychainWrapper.standard.set(refreshToken!, forKey: "refreshToken")
                        
                        print("The refresh token save result: \(saveRefreshToken)")
                        print(refreshToken!)
                        }
                        
                        if parseJSON["access_token"] != nil {
                        // Now we can access value of First Name by its key
                        let accessToken = parseJSON["access_token"] as? String
                        //print("Access token: \(String(describing: accessToken!))")
                        
                        let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                        
                        print("The access token save result: \(saveAccesssToken)")
                        print(accessToken!)
                        }
                        
                        
            
                        else {
                        
                            // Display an Alert dialog with a friendly error message
                            self.displayMessage(userMessage: "Invalid username or password")
                            return
                        
                        }
                        
                        DispatchQueue.main.async
                        {   let firstVC = TaskViewController()
                            self.navigationController?.pushViewController(firstVC, animated: true)
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
        
        func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
        {
            DispatchQueue.main.async
                {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
            }
        }
    

}
