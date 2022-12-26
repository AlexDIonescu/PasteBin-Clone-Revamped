//
//  MainViewController.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 08.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase
import FirebaseStorage
class MainViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.postsTableView.refreshControl = refreshControl
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let destVC = segue.destination as! DetailedPostViewController
            guard let index = postsTableView.indexPathForSelectedRow else {
                return
            }
            let cell = postsTableView.cellForRow(at: index) as! PostsCell
            destVC.title = cell.textLabel!.text
        
            destVC.emailValue = cell.email
            destVC.textValue = cell.detailTextLabel!.text!
        }
    }
    
    @objc func refresh() {
            self.getData()
            
            print(self.posts)
    }
    
    var posts = [Post]()
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBAction func getDataButtonTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: "Posts count: \(posts.count)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)

    }
    
    
    @IBOutlet weak var postsTableView: UITableView!
    
  
    func getData() {
        print("getting data....")
        posts = []
        let db = Database.database().reference().child("posts")
        DispatchQueue.main.async {
        db.observe(DataEventType.childAdded) { snapshot,arg   in
            if let data = snapshot.value as? [String: Any] {
                
                var post = Post()
                if let author = data["author"] as? String {
                    post.author = author
                    print("author")
                }
                if let text = data["post"] as? String {
                    post.text = text
                    print("post")
                    
                    
                }
                if let email = data["email"] as? String {
                    post.email = email
                    print("email")
                    
                    
                }
                //            if let photoURL = data["photoURL"] as? String {
                //
                //                post.userProfile = photoURL
                //                print("photoURL")
                //            }
                //
                //            print("before insert")
                //
                //                print(post.imageData)
                self.insertPost(post: post)
                
            }
        }
    }
    self.postsTableView.refreshControl?.endRefreshing()
        if self.posts.count == 0{
            let txt = UILabel()
            txt.text = "No posts yet..."
            txt.font = .boldSystemFont(ofSize: 30)
            txt.textAlignment = .center
            txt.frame = self.postsTableView.frame
            self.postsTableView.backgroundView = txt
        }
    db.removeAllObservers()
    }
    
//    func getImages(photoURL: String) -> Data {
//        var output : Data?
//        var defaultOutput : Data = UIImage(systemName: "person")!.pngData()!
//        if let url = URL(string: photoURL) {
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else {
//                    return
//                }
//                output = data
//
//            }
//            task.resume()
//        }
//        return output ?? defaultOutput
//    }
    
    func insertPost(post: Post) {
        print("\ninserting.....\n")
        posts.insert(post, at: 0)
        DispatchQueue.main.async(execute: {

            self.postsTableView.reloadData()
            if self.posts.count != 0 {
                self.postsTableView.backgroundView = nil
            }
        })
    }
    
    
    }
    
    
    

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "cell") as! PostsCell

        cell.textLabel?.text = posts[indexPath.row].author
        cell.detailTextLabel?.text = posts[indexPath.row].text
        cell.email = posts[indexPath.row].email
        DispatchQueue.main.async {
            cell.imageView?.image = UIImage(systemName: "person.circle")
        }
//        print("img:", posts[indexPath.row].userProfile)
//        if let data = Data(base64Encoded: posts[indexPath.row].userProfile) {
//            DispatchQueue.main.async {
//                cell.imageView?.image = UIImage(systemName: "person")
//
//            }
//        }

       
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
