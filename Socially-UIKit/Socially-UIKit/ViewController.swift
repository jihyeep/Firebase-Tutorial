//
//  ViewController.swift
//  Socially-UIKit
//
//  Created by 박지혜 on 7/25/24.
//

import UIKit
import FirebaseFirestore
import Kingfisher

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var db: Firestore!
    private var dataSource: UITableViewDiffableDataSource<Section, Post>!
    private var tableView: UITableView!
    private var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "text.bubble"), tag: 0)
        
        db = Firestore.firestore()
        configureTableView()
        configureDataSource()
        
        // Firebase와 DataSource 연동
        startListeningToFirestore()
    }
    
    deinit {
        listener?.remove()
    }
    
    func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")
        tableView.rowHeight = 280

    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Post>(tableView: tableView) { 
            (tableView, indexPath, item) -> UITableViewCell? in
            tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
            
            // Remove any existing subviews to avoid duplicates
            cell.contentView.subviews.forEach {
                $0.removeFromSuperview()
            }

            // Create an image view
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imageView.contentMode = .scaleAspectFit
            imageView.center = cell.contentView.center
            cell.contentView.addSubview(imageView)

            // Create a label for the title
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 200, width: cell.contentView.bounds.width, height: 20))
            titleLabel.textAlignment = .center
            titleLabel.text = item.description
            titleLabel.center = CGPoint(x: cell.contentView.center.x, y: cell.contentView.bounds.height - 20)
            cell.contentView.addSubview(titleLabel)

            // Load the image asynchronously using Kingfisher
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            imageView.kf.indicatorType = .activity
            imageView.image = UIImage(systemName: "photo.artframe")

            if let imageURL = item.imageURL {
                imageView.kf.setImage(
                    with: URL(string: imageURL)!,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ]
                )
            }
            
            return cell
            
        }
    }
    
    func startListeningToFirestore() {
        listener = db.collection("Posts").addSnapshotListener {
            [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            dump(documents)
            let posts = documents.compactMap { Post(document: $0) }
            self?.updateDataSource(with: posts)
        }
    }

    func updateDataSource(with posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

