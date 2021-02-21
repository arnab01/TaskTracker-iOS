//
//  TaskViewController.swift
//  Task Tracker
//
//

import UIKit
import SwiftKeychainWrapper

class TaskViewController : UITableViewController, ObservableObject {
    
    lazy var priorityAction = UIAction(title: "By Priority", image: UIImage(systemName: "exclamationmark.circle")) { action in
        self.fetchtasks(type: "https://jedischoolteam3.tk/sortp/Team1")
    }
    lazy var dateAction = UIAction(title: "By Date", image: UIImage(systemName: "calendar.badge.clock")) { action in
        self.fetchtasks(type: "https://jedischoolteam3.tk/sortpd/Team1") }
    lazy var orderAction = UIAction(title: "By Timeline", image: UIImage(systemName: "arrow.down.circle")) { action in
        self.fetchtasks(type: "https://jedischoolteam3.tk/task/Team1") }
    
    private var isLoadingTasks = false
    private var tasks: [Tasks] = []
    var status: String?
    private var activityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
            super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        view.backgroundColor = .secondarySystemBackground
        
        /*let cbutton:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        cbutton.backgroundColor = .black
        cbutton.setTitle("Add Task", for: .normal)
        cbutton.addTarget(self, action:#selector(self.CreateTaskDidClick), for: .touchUpInside)
        self.view.addSubview(cbutton)*/
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonDidClick))
        
        tableView.refreshControl = refreshControl
        refreshControl!.addTarget(self, action: #selector(fetch(_:)), for: .valueChanged)
        refreshControl!.attributedTitle = NSAttributedString(string: "Fetching Tasks ...")
        self.navigationItem.title = "Tasks"
        let button = UIButton(type: .system)
        button.setTitle("Sort", for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        let listImage = UIImage(systemName: "plus")
        let add = UIBarButtonItem(image: listImage, style: .plain, target: self, action: #selector(CreateTaskDidClick))
        navigationItem.rightBarButtonItems = [add, barButton]
        if #available(iOS 14.0, *) {
            button.showsMenuAsPrimaryAction = true
        } else {
            /// Fallback on earlier versions
        }
        if #available(iOS 14.0, *) {
            button.menu = UIMenu(title: "", children: [priorityAction, dateAction, orderAction])
        } else {
            /// Fallback on earlier versions
        }
        
        configureTableView()
        self.refresh()
        self.fetchtasks(type: "https://jedischoolteam3.tk/task/Team1")
    }

    @objc func logOutButtonDidClick() {
        let alertController = UIAlertController(title: "Log Out", message: "", preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: "Yes, Log Out", style: .destructive, handler: {
            alert -> Void in
            print("Logging out...");
                KeychainWrapper.standard.removeObject(forKey: "accessToken")
                KeychainWrapper.standard.removeObject(forKey: "refreshToken")
                let wc = WelcomeViewController()
                self.navigationController?.pushViewController(wc, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func CreateTaskDidClick(){
        let vc = CreateTaskViewController()
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    private func configureTableView() {
        tableView.register(Taskcell.self, forCellReuseIdentifier: Taskcell.reuseID)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.rowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Taskcell.reuseID, for: indexPath) as! Taskcell
        if(indexPath.row >= 0 && indexPath.row < tasks.count) {
            if tasks[indexPath.row].Status == "to-do" {
                cell.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            }
            else if tasks[indexPath.row].Status == "in-progress" {
                cell.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            }
            else if tasks[indexPath.row].Status == "done" {
                cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            }
            cell.setCell(with: tasks[indexPath.row])
            
        }
        print("setcell")
        return cell
    }
    
    
    private func updateUI(with tasks: [Tasks]) {
        self.tasks.append(contentsOf: tasks)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("yes")
        }

    }
    
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let task = tasks[indexPath.row]
            return UIContextMenuConfiguration(identifier: task.Title! as NSString, previewProvider: nil) { _ in
                let id = task.taskId
                print(id!)
                let status = task.Status
                let cell = tableView.dequeueReusableCell(withIdentifier: Taskcell.reuseID, for: indexPath) as! Taskcell
                if status == "to-do" {
                    cell.backgroundColor = UIColor.red
                }
                
                
                
                
                
                
                
                let ToDoAction = UIAction(
                          title: "To-Do",
                          image: UIImage(systemName: "note.text.badge.plus")) { _ in
                    self.updatetask(status: "to-do", id: id!)// copy the task content
                        }
                
                let InProgressAction = UIAction(
                          title: "In Progress",
                          image: UIImage(systemName: "hourglass")) { _ in
                    self.updatetask(status: "in-progress", id: id!)// copy the task content
                        }
                    
                let DoneAction = UIAction(
                          title: "Done",
                          image: UIImage(systemName: "checkmark.circle.fill")) { _ in
                    self.updatetask(status: "done", id: id!)// copy the task content
                        }
                
               
                let deleteAction = UIAction(
                  title: "Delete",
                  image: UIImage(systemName: "trash.fill"),
                  attributes: .destructive) { _ in
                    let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                            
                            // Create OK button with action handler
                            let ok = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                                 print("Ok button tapped")
                                self.deleteMethod(id: id!)
                                self.displayMessage(userMessage: "Task Deleted Succesfully")
                        
                            })
                            
                            // Create Cancel button with action handlder
                            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                                print("Cancel button tapped")
                            }
                            
                            //Add OK and Cancel button to dialog message
                            dialogMessage.addAction(ok)
                            dialogMessage.addAction(cancel)
                            
                            // Present dialog message to user
                            self.present(dialogMessage, animated: true, completion: nil)
                    
                    
                }
                return UIMenu(title: "", children: [ ToDoAction, InProgressAction, DoneAction, deleteAction])
            }
        }
    
    @objc private func fetch(_ sender: Any) {
        fetchtasks(type: "https://jedischoolteam3.tk/task/Team1")
        self.refreshControl!.endRefreshing()
        self.activityIndicatorView.stopAnimating()
        
    }
    
    func fetchtasks(type: String) {
        
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        guard let url = URL(string: type) else {
            self.displayMessage(userMessage: "Invalid URL")
            print("1")
            return
        }
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let _ = error {
                self.displayMessage(userMessage: "Unable to Complete")
                print("2")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.displayMessage(userMessage: "Invalid Response")
                print("3")
                return
            }
            
            guard let data = data else {
                self.displayMessage(userMessage: "Invalid Data")
                print("4")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let tasks = try decoder.decode([Tasks].self, from: data)
                print("Working")
                print(tasks)
                print(tasks.count)
                self.tasks.removeAll()
                self.updateUI(with: tasks)
                self.refresh()
            } catch {
                self.displayMessage(userMessage: "Unable to parse data")
            }
        })
        
        
        task.resume()
        
        
    }
    
    func refresh() {
        
        
        let refreshToken: String? = KeychainWrapper.standard.string(forKey: "refreshToken")
        print(refreshToken)
        let myUrl = URL(string: "https://jedischoolteam3.tk/refresh")
        var request = URLRequest(url:myUrl!)
       
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(refreshToken!)", forHTTPHeaderField: "Authorization")
        
        let postString = ["refresh_token": refreshToken!] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
        
         let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
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
                    {   //let firstVC = TaskViewController()
                        //self.navigationController?.pushViewController(firstVC, animated: true)
                    }
                    
                    
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
                
            } catch {
                
                
                // Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
            
            
            
            
         }
        task.resume()
        
        
        
    }
    
    func updatetask(status: String?, id: Int?) -> Void {
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        print(id!)
        print(status!)
        let myUrl = URL(string: "https://jedischoolteam3.tk/tasks/\(id!)")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "PUT"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        let postString = ["Status": status!,
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
                
                
                let userId = parseJSON["Assignee"] as? String
                print("User id: \(String(describing: userId!))")
                
                if (userId?.isEmpty)!
                {
                    // Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                    return
                } else {
                    self.fetchtasks(type: "https://jedischoolteam3.tk/task/Team1")
                    self.displayMessage(userMessage: "Successfully changed Task Status")
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
    
    func deleteMethod(id: Int?) {
            
    
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        
            guard let url = URL(string: "https://jedischoolteam3.tk/tasks/\(id!)") else {
                print("Error: cannot create URL")
                return
            }
        
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    self.fetchtasks(type: "https://jedischoolteam3.tk/task/Team1")
                   print("Delete Successful")
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
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
     
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height / 2
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !isLoadingTasks else { return }
            
        }
    }

}
extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}
