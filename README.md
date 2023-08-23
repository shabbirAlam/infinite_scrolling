# infinite scrolling iOS swift
Infinite scrolling using collectionView in iOS Swift

full code is in 'ScrollViewController.swift' file


https://github.com/shabbirAlam/infinite_scrolling/assets/67838198/9201d54c-70f9-46f3-bd31-60993530eeae


## Uses

1. Declare one buffer variable if you want the original array at later point of time.
```swift
private var list: [String] = ["One", "Two", "Three"] // To work properly, it should have more than 2 items.
private var bufferList: [String] = [] // temporary variable
private var lastContentOffset: CGFloat = 0
```

2. assign variable 'bufferList' if you have used it.
```swift
bufferList = list
```

3. Call `initialScroll()` method just after reloading the collectionView for the first time.
```swift
myCollectionView.reloadData()
initialScroll()
```

4. And in viewController add below methods
```swift
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
```

