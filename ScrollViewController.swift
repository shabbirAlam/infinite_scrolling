//
//  ScrollViewController.swift
//  Radius
//
//  Created by Md Shabbir Alam on 23/08/23.
//

import UIKit

final class ScrollViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
        // MARK: - Variables used for Infinite Scrolling logic
    private var list: [String] = ["One", "Two", "Three"]
    private var bufferList: [String] = []
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bufferList = list
        
        myCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        myCollectionView.reloadData()
        initialScroll()
    }
}

extension ScrollViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: myCollectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bufferList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.updateUI(with: bufferList[indexPath.row])
        return cell
    }
    
        // MARK: - Infinite Scrolling logic for both sides
        /// Call this method just after reloading the collectionView for the first time
    func initialScroll() {
        Task{
            bufferList.insert(bufferList.remove(at: bufferList.count - 1), at: 0)
            myCollectionView.reloadData()
            myCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                         at: .left, animated: false)
            lastContentOffset = myCollectionView.contentOffset.x
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.x,
           lastContentOffset == myCollectionView.frame.width {
            bufferList.insert(bufferList.remove(at: bufferList.count - 1), at: 0)
            myCollectionView.reloadData()
            myCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                         at: .left, animated: false)
        } else if lastContentOffset < scrollView.contentOffset.x,
                  scrollView.contentOffset.x > 0,
                  scrollView.contentOffset.x == CGFloat((bufferList.count - 1)) * myCollectionView.frame.width {
            bufferList.append(bufferList.remove(at: 0))
            myCollectionView.reloadData()
            myCollectionView.scrollToItem(at: IndexPath(item: bufferList.count - 2, section: 0),
                                         at: .left, animated: false)
            
        }
        lastContentOffset = scrollView.contentOffset.x
    }
        // Infinite Scrolling logic ends here
}
