//  ListTableViewController.swift
//  OnTheMap
//
//  Created by William K Hughes on 10/18/20.
//


import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Outlets and Properties
    
    @IBOutlet weak var studentTableView: UITableView!
    
    var students = [StudentInformation]()
    var myIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        myIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(myIndicator)
        myIndicator.bringSubviewToFront(self.view)
        myIndicator.center = self.view.center
        showActivityIndicator()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    // MARK: Logout
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        showActivityIndicator()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator()
            }
        }
    }
    
    // MARK: Refresh list
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    // MARK: Get list of students
    
    func getStudentsList() {
        showActivityIndicator()
        UdacityClient.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
    
    // MARK: Show/Hide Activity Indicator
    
    func showActivityIndicator() {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        myIndicator.stopAnimating()
        myIndicator.isHidden = true
    }
    
}
