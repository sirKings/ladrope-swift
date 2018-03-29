//
//  CommentViewController.swift
//  app
//
//  Created by MAC on 3/13/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Alamofire

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var commentsArray = [Comment]()
    var key: String?
    var numComment: Int?
    var cUser = MyUser()
    
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var commentsList: UITableView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        commentsList.delegate = self
        commentsList.dataSource = self
        commentsList.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        
        commentsList.addGestureRecognizer(tapGesture)
        
        commentsList.rowHeight = UITableViewAutomaticDimension
        commentsList.estimatedRowHeight = 100.0
        
        getComment()
        getNumComment()
        getUser()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "commentViewCell", for: indexPath) as! CommentViewCell
        
        commentCell.title.text = commentsArray[indexPath.row].title
        commentCell.comment.text = commentsArray[indexPath.row].message
        
        return commentCell
    }
    
    
    
    @objc func tableViewTapped() {
        commentText.endEditing(true)
    }
    
    func getComment(){
        let commentREf = Database.database().reference().child("cloths").child(GENDER).child(key!).child("comment")
        commentREf.observe(.childAdded){
            snapshot in
            
            let snapVal = snapshot.value as! Dictionary<String,Any?>
            let title = snapVal["title"]! as! String
            let message = snapVal["message"]! as! String
            
            let comment = Comment()
            
            comment.title = title
            comment.message = message
            self.commentsList.register(UINib(nibName: "CommentViewCell", bundle: nil), forCellReuseIdentifier: "commentViewCell")
            self.commentsArray.append(comment)
            
            self.commentsList.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        saveComment()
    }
    
    func saveComment(){
        if commentText.text == "" {
            
        }else {
            let cref = Database.database().reference().child("cloths").child(GENDER).child(key!).child("comment")
            let newComment: Dictionary<String, String> = ["title": cUser.displayName!, "message": commentText.text]
            let pushKey = Database.database().reference().child("cloths").child(GENDER).child(key!).child("comment").childByAutoId().key
            
            cref.child(pushKey).setValue(newComment){
                (error, res) in
                print(res)
                let numCommentRef = Database.database().reference().child("cloths").child(GENDER).child(self.key!).child("numComment")
                numCommentRef.setValue((self.numComment! + 1)){
                    (error, res) in
                    self.reportComment(comment: self.commentText.text)
                    self.commentText.text = ""
                }
            }
            print(["title": cUser.displayName!, "message": commentText.text], pushKey)
        }
    }
    
    func getNumComment(){
        let numCommentRef = Database.database().reference().child("cloths").child(GENDER).child(self.key!).child("numComment")
        numCommentRef.observe(.value){
            snapshot in
            
            if let num = snapshot.value as? Int{
                self.numComment = num
            }else{
                self.numComment = 0
            }
        }
    }
    
    func getUser(){
        let userRef = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        userRef.observe(.value){
            snapshot in
            if let user = snapshot.value as! Dictionary<String, Any>? {
                let name = user["displayName"] as! String
                self.cUser.displayName = name
                print(name)
            }
        }
    }
    
    func reportComment(comment: String){
        let parameters = ["uid": Auth.auth().currentUser!.uid, "clothKey": key, "comment": comment]
        Alamofire.request(COMMENT_REPORT_URL, method: .post, parameters: parameters)
    }
    
}
