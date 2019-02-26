//
//  ViewController.swift
//  Blogger
//
//  Created by IMCS2 on 2/22/19.
//  Copyright © 2019 IMCS2. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    var selectedUrl:String = "https://www.google.com"
    var blogs:[NSManagedObject]  = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Blog_Cell") as! UITableViewCell
    let blog = blogs[indexPath.row]
         cell.textLabel?.text = blog.value(forKeyPath: "title") as? String
        return cell
    }
    
    func save(title: String,url:String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Blogs",
                                       in: managedContext)!
        
        let blog = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        blog.setValue(title, forKeyPath: "title")

        blog.setValue(url  , forKeyPath: "url")

        
        //  blog.setValue(, forKey:     )
        // 4
        do {
            try managedContext.save()
            blogs.append(blog)
            print("saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = blogs[indexPath.row].value(forKey: "url") as! String
        
        performSegue(withIdentifier: "WebViewSegue", sender: self)
        
    }

    @IBOutlet weak var blogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let myURL = URL(string:"https://www.googleapis.com/blogger/v3/blogs/2399953?maxPosts=30&&key=AIzaSyAZfqMekYDYsGwAEnrH9R_4F-UCyvEAADE")
        print("here")
        let task = URLSession.shared.dataTask(with: myURL!){ (data,response,error) in
            print("?")
            DispatchQueue.main.async {
                
                
                if let unrappedData = data{
                    
                    do{
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: unrappedData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        let posts = jsonResult?["posts"] as! NSDictionary
                        let items = posts["items"] as! NSArray
                        
                        var count = 0
                        while count < 30 {
                        let itemAtIndex = items[count] as! NSDictionary
                            let currentURL = itemAtIndex["url"] as! String
                            let title = itemAtIndex["title"] as! String

                            self.save(title: title,url: currentURL)
                            count += 1
                            print(count)
                            self.blogTableView.reloadData()

                        }
                        
                    }
                    catch{
                        print("error")
                    }
                }
                
                
                
            }
            
        }
        task.resume()
       
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebViewSegue"{
            let destination = segue.destination as! WebViewController
            destination.webLink = selectedUrl
            //print("set")
        }
    }


}

