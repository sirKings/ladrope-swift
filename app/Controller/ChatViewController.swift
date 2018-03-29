//
//  ChatViewController.swift
//  app
//
//  Created by MAC on 3/12/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CodableFirebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewsCellProtocol {
   
    
    
    var newsArray = [NewsItem]()
    var link: String?

    @IBOutlet weak var newsList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        newsList.delegate = self
        newsList.dataSource = self
        newsList.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "newsViewCell")
        
        newsList.separatorStyle = .none
        newsList.rowHeight = 300
        
        SVProgressHUD.show()
        getNews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if segue.identifier == "goToWeb" {
//            let wVC = segue.destination as! WebViewController
//            
//            wVC.link = link!
//        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsViewCell", for: indexPath) as! NewsViewCell
        cell.newsDescription.text = newsArray[indexPath.row].description
        cell.newsTitle.text = newsArray[indexPath.row].title
        
        let imgUrl = URL(string: newsArray[indexPath.row].image!)
        cell.newsImage.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "ladAccount"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.link = newsArray[indexPath.row].link!
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        link = newsArray[indexPath.row].link!
        //print(link)
        //performSegue(withIdentifier: "goToWeb", sender: self)
    }
    
    
    
    func getNews(){
        let newsRef = Database.database().reference().child("blog")
        newsRef.observe(.childAdded){
            snapshot in
            
            guard let value = snapshot.value else { return }
            do {
                let news = try FirebaseDecoder().decode(NewsItem.self, from: value)
                //print(news)
                self.newsArray.append(news)
                SVProgressHUD.dismiss()
                self.newsList.reloadData()
            } catch let error {
                print(error)
            }
        }
    }
    
//    func seeMore(cell: NewsViewCell) {
//        link = cell.link
//        print(link)
//        performSegue(withIdentifier: "goToWeb", sender: self)
//
//    }
    
    func seeMore(cell: NewsViewCell) {
        let mywebViewController = UIViewController()
        let webView = UIWebView(frame: mywebViewController.view.bounds)
        
        let url = URL(string: cell.link!)
        let request = URLRequest(url: url!)
        
        webView.loadRequest(request) // url from the row a user taps
        let navController = UINavigationController(rootViewController: mywebViewController)
        mywebViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dimiss))
        mywebViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0, green: 74/255, blue: 0, alpha: 1)
        mywebViewController.view = webView
        present(navController, animated: true, completion: nil)

    }
    
    @objc func dimiss(){
        self.dismiss(animated: true, completion: nil)
    }

}
