//
//  PostListViewController.swift
//  EngineerAI
//
//  Created by Apple on 29/04/19.
//  Copyright © 2019 Hitendra iDev. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    let reachability = Reachability()
    var rootData: Algolia = Algolia()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //start observing rechability
        self.handleRechability()
        
        //setup tableview
        self.tableview.cr.addHeadRefresh {
            OperationQueue.main.addOperation {
                self.tableview.cr.resetNoMore()
            }
            self.loadPosts(pageNumber: 0)
        }
        self.tableview.cr.addFootRefresh {
            self.loadPosts(pageNumber: self.rootData.page+1)
        }
        
        //trigger initial data load
        self.tableview.cr.beginHeaderRefresh()
    }
    
    
    func handleRechability(){
        
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability?.whenUnreachable = { _ in
            print("Not reachable")
            OperationQueue.main.addOperation {
                let alert = UIAlertController(title: "Engineer.ai", message: "Internet connection is not available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        reachability?.stopNotifier()
    }
}

//MARK: Tableview Datasource and Delegates
extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rootData.hits.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequequeCell()
        cell.post = self.rootData.hits[indexPath.row]
        cell.selectionDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else {
            return
        }
        cell.toggleCellSelection()
    }
}

//MARK:- PostTableViewCellSelectionDelegate - Post Selection delegate updates
extension PostListViewController: PostTableViewCellSelectionDelegate {
    func postTableViewCell(cell: PostTableViewCell, selectionValueDidChange post: Post) {
        self.updateSelectionCounter()
    }
    func updateSelectionCounter(){
        let selectedPosts = self.rootData.hits.selectedValues.count
        self.title = selectedPosts > 0 ? "Selected \(selectedPosts)" : ""
    }
}


//MARK:- Data load operations
//Basically I create saprete data load classes, which are only responsible for data load only
extension PostListViewController {
    func loadPosts(pageNumber: Int){
        
        guard self.reachability?.connection != .none else {
            OperationQueue.main.addOperation {
                self.tableview.cr.endHeaderRefresh()
                self.tableview.cr.endLoadingMore()
                
                let alert = UIAlertController(title: "Engineer.ai", message: "Internet connection is not available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        
        let urlString : String = "https://hn.algolia.com/api/v1/search_by_date?tags=story&page=\(pageNumber)"
        let url = URL(string: urlString)!
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            OperationQueue.main.addOperation {
                self.tableview.cr.endHeaderRefresh()
                self.tableview.cr.endLoadingMore()
            }
            
            guard error == nil else {
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Engineer.ai", message: "Something went wrong, please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            guard let data = data else {
                print("Guard data nil")
                return
            }
            do {
                let decoder = JSONDecoder()
                let algoliaData = try decoder.decode(Algolia.self, from: data)
                
                if pageNumber == 0 {
                    self.rootData = algoliaData
                }else{
                    
                    self.rootData.page = pageNumber
                    self.rootData.hits.append(contentsOf: algoliaData.hits)
                }
                
                print("self.data.nbPages := \(self.rootData.nbPages)")
                print("self.data.page := \(self.rootData.page)")
                if self.rootData.nbPages <= self.rootData.page {
                    OperationQueue.main.addOperation {
                        self.tableview.cr.noticeNoMoreData()
                    }
                }
                
                OperationQueue.main.addOperation {
                    OperationQueue.main.addOperation {
                        self.updateSelectionCounter()
                    }
                    self.tableview.reloadData()
                }
                
            } catch {
                OperationQueue.main.addOperation {
                    let alert = UIAlertController(title: "Engineer.ai", message: "Data is not in correct format, JSON format is expected", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            }.resume()
    }
}




