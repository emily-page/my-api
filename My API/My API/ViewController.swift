//
//  ViewController.swift
//  My API
//
//  Created by apcs2 on 2/26/18.
//  Copyright © 2018 apcs2. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var myTableView: UITableView!
    
    var fetchedCountry = [Country]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Data"
        parseData()
    }
    
    func parseData()
    {
        fetchedCountry = []
        let url = "https://restcountries.eu/rest/v1/all"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil)
            {
                print("Error")
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    for eachFetchedCountry in fetchedData{
                        let eachCountry = eachFetchedCountry as! [String : Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                    }
                    self.myTableView.reloadData()
                }
                catch {
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell")
        cell?.textLabel?.text = fetchedCountry[indexPath.row].country
        cell?.detailTextLabel?.text = fetchedCountry[indexPath.row].capital
        return cell!
    }
    
    class Country
    {
        var country: String
        var capital : String
        init(country: String, capital: String)
        {
            self.country = country
            self.capital = capital
        }
    }
    
}

