//
//  FavoriteStationsViewController.swift
//  AirQ
//
//  Created by aeronaut on 01.02.2018.
//  Copyright © 2018 aeronaut. All rights reserved.
//

import UIKit

class FavoriteStationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.backgroundColor = UIColor.black
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if section == 0 {
            rows = 5
        }
        if section == 1 {
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "favoriteStation", for: indexPath)
            cell.backgroundColor = UIColor.black
        }
        if indexPath.section == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: "addStation", for: indexPath)
            cell.backgroundColor = UIColor.black

        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = "abc"
        }
        if section == 1 {
            title = "def"
        }
        return title
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
