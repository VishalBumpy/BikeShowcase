//
//  BikeDetailsViewController.swift
//  BikeShowcase
//
//  Created by Vishal on 24/12/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit

class BikeDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bikeID:String!
    var bname:String?
    var city:String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bikeName: UILabel!
    @IBOutlet weak var locationName: UILabel!
    
    var stationNameArray = [String]()
    var idArray = [String]()

    
    final let urlString = "https://api.citybik.es/v2/networks/"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Check network connectivity
        if Reachability.isConnectedToNetwork(){
            //setting up activity indicator
            _ = Utils.customActivityIndicatory(self.view, startAnimate: true)
            //call the api
            self.getDetailsURL()
        }
        else{
            
            let alertController = UIAlertController(title: "No Internet", message: "Please check your connectivity and retry !", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                print("You've pressed ok");
            }
            
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getDetailsURL() {
        
        
        let appendUrl = urlString + self.bikeID
        let url = NSURL(string: appendUrl)
        
        autoreleasepool {
            
            URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
                
                if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                    
                    print(jsonObj!.value(forKey: "network") as Any)
                    
                    if let bikeDict = jsonObj!.value(forKey: "network") as? NSDictionary {
                        
                        self.bname = bikeDict.value(forKey: "name") as? String ?? "No bike name"
                        
                        let cnameDict = bikeDict.value(forKey: "location") as? NSDictionary
                        self.city = cnameDict?.value(forKey: "city") as? String ?? "No city name"
                        
                        if let stnArray = bikeDict.value(forKey: "stations") as? NSArray {
                            print(stnArray)
                            for stn in stnArray{
                                print(stn)
                                if let stnDict = stn as? NSDictionary {
                                    if let name = stnDict.value(forKey: "name") {
                                        self.stationNameArray.append(name as! String)
                                    }
                                    if let ids = stnDict.value(forKey: "id") {
                                        self.idArray.append(ids as! String)
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    
                    OperationQueue.main.addOperation({
                        //removing activity indicator and loading table view
                        _ = Utils.customActivityIndicatory(self.view, startAnimate: false)
                        self.bikeName.text = self.bname
                        self.locationName.text = self.city
                        self.tableView.reloadData()
                    })
                    
                }
            }).resume()
        }
    }
    
    
    
    //MARK: Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.stationNameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BikeDetailsTableViewCell = (self.tableView?.dequeueReusableCell(withIdentifier: "customCell") as! BikeDetailsTableViewCell!)
        
        cell.stationName.text = stationNameArray[indexPath.row]
        cell.slots.text = idArray[indexPath.row]
    
        
        return cell
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
