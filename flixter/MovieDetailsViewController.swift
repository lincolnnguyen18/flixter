//
//  MovieDetailsViewController.swift
//  flixter
//
//  Created by Lincoln Nguyen on 2/5/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    // @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var synopsisLabel: PaddingLabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var backdropConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterDistance: NSLayoutConstraint!
    @IBOutlet weak var synopLeft: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    var movie: [String:Any]!
    
    // override func loadView() {
    //     super.loadView()
    //     updateDetailView()
    // }
    //
    // override func viewDidLayoutSubviews() {
    //     updateDetailView()
    //     super.viewDidLayoutSubviews()
    // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        
        updateDetailView(transitionSize: nil)
        // Do any additional setup after loading the view.
        print(movie["title"] ?? "No title available.")
        
        titleLabel.text = movie["title"] as? String
        // titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        releaseDateLabel.text = movie["release_date"] as? String
        releaseDateLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        posterView.layer.masksToBounds = true
        posterView.layer.borderWidth = 1.5
        posterView.layer.borderColor = UIColor.white.cgColor
        // posterView.layer.cornerRadius = posterView.bounds.width / 25
        
        if let backdropPath = movie["backdrop_path"] as? String {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            backdropView.af.setImage(withURL: backdropUrl!)
        } else {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + posterPath)
            backdropView.af.setImage(withURL: backdropUrl!)
        }
        // let backdropPath = movie["backdrop_path"] as! String
        // if !backdropPath.isEmpty {
        //     let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        //     backdropView.af.setImage(withURL: backdropUrl!)
        // }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateDetailView(transitionSize: size)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        // find selected movie id
        let movieId = movie["id"] as! Int
        // pass it to movie trailer view controller
        let movieTrailerViewControllerNavController = segue.destination as! UINavigationController
        let movieTrailerViewController = movieTrailerViewControllerNavController.topViewController as! MovieTrailerViewController
        movieTrailerViewController.movieId = movieId
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 0) {
            // scrollView.isScrollEnabled = false
            // let anim = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.5) {
            //     scrollView.isScrollEnabled = false
            //     scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            //     scrollView.isScrollEnabled = true
            // }
            // anim.startAnimation()
            print("scrolled past top!")
            scrollView.isScrollEnabled = false
            scrollView.bounces = false
        } else {
            scrollView.isScrollEnabled = true
            scrollView.bounces = true
        }
        // scrollView.bounces = true
        // print("scrolling past top!")
    }
    
    private func updateDetailView(transitionSize: CGSize?) {
        // synopTop.isActive = false
        
        let synopToDate = synopsisLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8)
        let synopToBackdrop = synopsisLabel.topAnchor.constraint(equalTo: backdropView.bottomAnchor, constant: 70)
        let titleConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 26.33)
        
        print("updateDetailView called")
        var size = UIScreen.main.bounds.size
        if transitionSize != nil {
            size = transitionSize ?? UIScreen.main.bounds.size
        }
        if size.width < size.height {
            print("Portrait: \(size.width) X \(size.height)")
            // print("Detail \(size.width)")
            let newMultiplier:CGFloat = 0.643857
            backdropConstraint = backdropConstraint.setMultiplier(multiplier: newMultiplier)
            posterDistance.constant = -133
            synopLeft.constant = 16
            // synopTop.constant = 54.67
            synopToDate.isActive = false
            synopToBackdrop.isActive = true
            titleConstraint.isActive = false
            titleLabel.numberOfLines = 2
            synopsisLabel.topInset = 40
        } else {
            print("Landscape: \(size.width) X \(size.height)")
            // print("Detail \(size.width)")
            // self.backdropConstraint.constant = 0.1
            let newMultiplier:CGFloat = 0.4
            backdropConstraint = backdropConstraint.setMultiplier(multiplier: newMultiplier)
            posterDistance.constant = -50
            synopLeft.constant = 163 + 12
            // synopTop.constant = 8
            synopToDate.isActive = true
            synopToBackdrop.isActive = false
            titleConstraint.isActive = true
            titleLabel.numberOfLines = 1
            synopsisLabel.topInset = 0
        }
        // posterView.heightAnchor.constraint(equalToConstant: 228).isActive = true
        // posterView.widthAnchor.constraint(equalToConstant: 147).isActive = true
        UIView.animate(withDuration: 0.1) {
            self.backdropView.updateConstraints()
            self.posterView.updateConstraints()
            self.synopsisLabel.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
