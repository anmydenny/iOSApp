//
//  ViewController.swift
//  MyApp
//
//  Created by anmy on 06/08/22.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var employeeTV: UITableView!
    var names: [String] = []
    var employee: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeTV.delegate = self
        employeeTV.dataSource = self
        title = "Employee List"
        employeeTV.register(UITableViewCell.self,forCellReuseIdentifier: "EmployeeTableViewCell")
        getResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)

      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }

      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")

      do {
          employee = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    func getResult(){
        let url = "http://www.mocky.io/v2/5d565297300000680030a986"
        WebServiceHandler.shared.getData(method: .get, api: url, params: [:]) { (response:DataResponse<EmployeeDetails>) in
            if let result = response.result.value{
                for employee in result{
                    self.save(name: employee.name ?? "",profile_image: employee.profileImage ?? "",company: employee.company?.name ?? "")
                }
                self.fetchData()
                self.employeeTV.reloadData()
            }else{
                self.showBasicAlert(title: "", message: response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func save(name: String,profile_image: String, company: String) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }

      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext)!
      let employees = NSManagedObject(entity: entity, insertInto: managedContext)
        employees.setValue(name, forKeyPath: "name")
        employees.setValue(profile_image, forKey: "profile_image")
        employees.setValue(company, forKey: "company")

      do {
        try managedContext.save()
          employee.append(employees)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func fetchData(){

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")

        do {
            let results = try context.fetch(fetchRequest)
            let  dateCreated = results as! [Employee]

            for _datecreated in dateCreated {
                employee.append(_datecreated)
            }
        }catch let err as NSError {
            print(err.debugDescription)
        }


    }

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employee.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let person = employee[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath)  as! EmployeeTableViewCell
    cell.nameLbl?.text = person.value(forKeyPath: "name") as? String
    return cell
  }
}

extension UIViewController{
     func showBasicAlert(title:String,message:String){
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                      self.dismiss(animated: true, completion: nil)
         }
         alert.addAction(okAction)
        DispatchQueue.main.async {
             self.present(alert, animated: true, completion: nil)
        }
     }
     
      func showAlertWithActions(title:String,message:String,alertActions:[UIAlertAction]){
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         for eachAction in alertActions {
             alert.addAction(eachAction)
         }
         DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
         }
     }
}
