//
//  SearchViewController.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var clothList = [Cloth]()
    var tempClothList = [Cloth]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchClothList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchClothList.delegate = self
        searchClothList.dataSource = self
        searchClothList.separatorStyle = .none
        
        searchClothList.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "searchViewCell")
        
        SVProgressHUD.show()
        getCloth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchClothList.dequeueReusableCell(withIdentifier: "searchViewCell", for: indexPath) as! SearchViewCell
        let url = URL(string: clothList[indexPath.row].image1!)
        cell.searchClothImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock:nil, completionHandler: nil)
        cell.searchClothName.text = clothList[indexPath.row].name!.capitalized
        cell.searchClothLabel.text = clothList[indexPath.row].label!.capitalized
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == ""{
            
        }else{
            clothList.removeAll()
            clothList = tempClothList.filter { ($0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToClothFromSearchView", sender: indexPath)
    }
    
    

    /*
    // MARK: - Navigation
 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToClothFromSearchView"{
            let clothView = segue.destination as! ClothViewController
            let index = sender as! NSIndexPath
            clothView.cloth = clothList[index.row]
            
        }
        
    }
    
    func getCloth(){
        let clothRef = Database.database().reference().child("cloths").child(GENDER).queryOrdered(byChild: "date")
        clothRef.observe(.childAdded){
            snapshot in
            
            let snapVal = snapshot.value as! Dictionary<String,Any?>
            let name = snapVal["name"]! as! String
            let label = snapVal["label"]! as! String
            let image = snapVal["image1"]! as! String
            let key = snapVal["clothKey"]! as! String
            
            let cloth = Cloth()
            cloth.name = name
            cloth.label = label
            cloth.clothKey = key
            cloth.image1 = image
            self.clothList.append(cloth)
            self.tempClothList.append(cloth)
            SVProgressHUD.dismiss()
            self.searchClothList.reloadData()
            
        }
    }
 

}
