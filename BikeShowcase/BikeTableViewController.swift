//
//  BikeTableViewController.swift
//  BikeShowcase
//
//  Created by Vishal on 24/12/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class BikeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
    final let urlString = "https://api.citybik.es/v2/networks"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var bItemArray = [bItem]()
    
    var searchController = UISearchController()
   
    var myActivityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting up search bar
          setUpSearchBar()
        
        //setting up activity indicator
        _ = Utils.customActivityIndicatory(self.view, startAnimate: true)
        //call the api
        self.downloadJsonWithURL()
    }
    
    //MARK: - search bar related
    fileprivate func setUpSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["name","company name"]
        searchBar.selectedScopeButtonIndex = 0
        
        searchBar.delegate = self
        
        self.tableView.tableHeaderView = searchBar
    }
    
    
    func downloadJsonWithURL() {
        let url = NSURL(string: urlString)
        
        autoreleasepool {
            
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                print(jsonObj!.value(forKey: "networks") as Any)
                
                if let bikeArray = jsonObj!.value(forKey: "networks") as? NSArray {
                    
                    for bike in bikeArray{
                        
                        if let bikeDict = bike as? NSDictionary {
                            
                            let bid = bikeDict.value(forKey: "id") as? String ?? "No bike ID"
                            
                            let cnameArr = bikeDict.value(forKey: "company") as? NSArray
                            let cname = cnameArr?.firstObject as? String ?? "No company name"
                        
                            let name = bikeDict.value(forKey: "name") as? String ?? "No bike name"
                            
                            CoreDataManager.storeObj(bid: bid, cname: cname, name: name)
                            
                        }
                    }
                }
                
                    self.updateData()
                
            }
        }).resume()
        }
    }
   
    
    func updateData() {
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            self.bItemArray = CoreDataManager.fetchObj()
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                //removing activity indicator and loading table view
                _ = Utils.customActivityIndicatory(self.view, startAnimate: false)
                self.tableView.reloadData()
            }
        }
        
    }
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bItemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BikeTableViewCell = (self.tableView?.dequeueReusableCell(withIdentifier: "customCell") as! BikeTableViewCell!)
        
        
        let bkItem = self.bItemArray[indexPath.row]
        
        let string1 = "Bike Name->> "
        let appendString = string1 + bkItem.name!
        cell.bikeName.text = appendString
        
        cell.detailsImageView.image = UIImage(named: "details")
        cell.bikeCompanyName.text = bkItem.cname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BikeDetailsViewController") as! BikeDetailsViewController
        
        let bkID = self.bItemArray[indexPath.row]
        vc.bikeID = bkID.bid
        
        self.navigationController?.show(vc, sender: nil)
    }
    
    //MARK: - Search the tableView
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            bItemArray = CoreDataManager.fetchObj()
            tableView.reloadData()
            return
        }
        
        bItemArray = CoreDataManager.fetchObj(selectedScopeIdx: searchBar.selectedScopeButtonIndex, targetText:searchText)
        tableView.reloadData()
        
        print(searchText)
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
