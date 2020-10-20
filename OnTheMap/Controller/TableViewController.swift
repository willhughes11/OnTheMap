//  ListTableViewController.swift
//  OnTheMap
//
//  Created by William K Hughes on 10/18/20.
//


import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var studentTableView: UITableView!
    
    var students = [StudentInformation]()
    var myIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        myIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(myIndicator)
        myIndicator.bringSubviewToFront(self.view)
        myIndicator.center = self.view.center
        myIndicator.isHidden = false
        myIndicator.startAnimating()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.myIndicator.stopAnimating()
                self.myIndicator.isHidden = true
            }
        }
    }
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    func getStudentsList() {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
        UdacityClient.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.myIndicator.stopAnimating()
                self.myIndicator.isHidden = true
                self.tableView.reloadData()
            }
            if (error != nil) {
                DispatchQueue.main.async {
                    self.showAlert(message: error?.localizedDescription ?? "", title: "Data Load Failure")
                }
            }
        }
    }
    
    func showLoadFailure(message: String) {
        let alertVC = UIAlertController(title: "Data Load Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
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
}
