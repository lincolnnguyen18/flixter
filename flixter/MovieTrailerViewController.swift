//
//  MovieTrailerViewController.swift
//  flixter
//
//  Created by Lincoln Nguyen on 2/6/21.
//

import UIKit

class MovieTrailerViewController: UIViewController {
    var trailers = [[String:Any]]()
    var movieId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // print(movi!eId)
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + String(movieId) + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // TODO: Get trailers
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Store the trailers in a property to use elsewhere
                self.trailers = dataDictionary["results"] as! [[String:Any]]
                print(self.trailers)
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
